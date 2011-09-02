#!/usr/bin/env python
#vim: encoding:iso-8859-15

import sys
import os.path as path
from datetime import datetime,timedelta

__author__  = 'José Miguel Sánchez Alés <sio2sio2 AT gmail DOT com>'
__version__ = '0.0.1'
__date__    = '2010-04-20'
__licence__ = 'GPLv2'
__doc__     = """%s, version %s (%s):
Utilidad para la consulta de la factura de pepephone.com""" % ((path.basename(sys.argv[0]),__version__,__date__))

class MiPepephone(object):

   class Scrapper(object):
      "Extrae las web de pepephone.com"

      import urllib, urllib2, cookielib
      root_name='https://www.pepephone.com/ppm_web/ppm_web/1/'

      def __init__(self,user,pwd):

         opener=MiPepephone.Scrapper.urllib2.build_opener(MiPepephone.Scrapper.urllib2.HTTPCookieProcessor(MiPepephone.Scrapper.cookielib.LWPCookieJar()))
         MiPepephone.Scrapper.urllib2.install_opener(opener)

         url='mipepephone/xweb_cliente.info_sesion.html'
#         print 'Obteniendo la página principal de pepephone... ',
         self.connect(url)
#         print 'Hecho'

         url='mipepephone/xweb_cliente.login.xml'
         data = {
                  'p_email':     user,
                  'p_pwd': pwd
                }
#         print 'Iniciando sesión... ',
         self.xsid=MiPepephone.Parser.compr_identidad((self.connect(url,data)))
#         print 'Hecho'

         url='mipepephone/xweb_cliente.lista_usuario_registrado.html?' + MiPepephone.Scrapper.urllib.urlencode({'xsid': self.xsid})
#         print 'Terminando la autentificación... ',
         self.homepage=self.connect(url)
#         print 'Hecho'

      def connect(self,url,data=None,headers={}):
         "Conecta a la url indicada"
         url=MiPepephone.Scrapper.root_name+url
         if data is not None:
            data=MiPepephone.Scrapper.urllib.urlencode(data)
         try:
            req=MiPepephone.Scrapper.urllib2.Request(url,data,headers)
            handle=MiPepephone.Scrapper.urllib2.urlopen(req)
         except IOError,e:
            message='Error al abrir %s\n' % url
            if hasattr(e,'code'):
               message+='Codigo de error: %s' % e.code
            elif hasattr(e,'reason'):
               message+='La causa del error es %s. Muy posiblemente no tenga internet o no exista el servidor.' % e.reason
            raise IOError, message
         else:
            return handle

      def detalle_llamadas(self,num,ini,fin):
         "Descarga la página de detalle de llamadas"

         url='detalle_llamadas/xweb_servicios.detalle_llamadas.html?' + MiPepephone.Scrapper.urllib.urlencode({'xsid': self.xsid})
         data= {
                  'p_msisdn': num,
                  'p_fecini': ini,
                  'p_fecfin': fin,
                  'p_orden': 'ASC',
                  'p_numpag': '1',
                  'p_numreg': '1000',
                  'xres': 'C'
               }
         print 'Obteniendo las llamadas entre %s y %s... ' % (ini,fin),
         res=self.connect(url,data)
         ### Esto sirve para guardar la pagina de llamadas en un fichero.
         res=res.read()
         fic=open('llamaditas.html','w')
         fic.write(res)
         fic.close()
         # Fin
         print 'Hecho <br>'
         return res

   class Parser(object):
      "Extrae los datos de parseando el html"

      from BeautifulSoup import BeautifulSoup

      @staticmethod
      def extrae_tels(page):
         "Extrae los numeros de telefono del cliente"
         import re

         html=MiPepephone.Parser.BeautifulSoup(page)
         nums=html.find('table',attrs= {'class':'estado'}).findAll('td',attrs={'class':'num'})
         return [x.find(text=re.compile('[0-9]+')) for x in nums]

      @staticmethod
      def extrae_detalles(page):
         html=MiPepephone.Parser.BeautifulSoup(page)
         res=[]
         try:
            for tr in html.findAll('table',attrs={'class':'resultados_detalle'})[1].findAll('tr')[2:]:
               res.append([td.string.strip() for td in tr if td.__class__.__name__=='Tag'])
         except IndexError: # No hay llamadas en el periodo solicitado
            pass
         return res

      @staticmethod
      def compr_identidad(page):
         xml=MiPepephone.Parser.BeautifulSoup(page)
         if xml.first().name=='error':
            #Podría ser más claro el mensaje.
            raise ValueError, 'No se ha podido realizar la autentificación'
         else:
            return xml.contents[0]['ses']

   def __init__(self,user,pwd):
      self.conn = MiPepephone.Scrapper(user,pwd)
      self.nums = MiPepephone.Parser.extrae_tels(self.conn.homepage)

   def llamadas(self,num,ini,fin):
      return MiPepephone.Parser.extrae_detalles(self.conn.detalle_llamadas(num,ini,fin))
#      return MiPepephone.Parser.extrae_detalles(open('llamaditas.html','r').read())

def s2d(seg):
   "Transforma segundos en minutos:segundos"
   return '%d:%02d' % (seg//60,seg%60)

def d2s(duracion):
   "Transforma minutos:segundos en segundos"
   min,seg=[int(x) for x in duracion.split(':')]
   return min*60+seg

class Llamada(tuple):
   """Almacena los datos de cada llamada:
      * Tipo ('llamada','sms','mms', etc.)
      * Fecha.
      * Hora.
      * Teléfono.
      * Destino (si es a FIJO, MOVISTAR, ORANGE, etc.).
      * Duración (en segundos).
      * Coste (en euros).
   """

   def __new__(cls,vect,ini):
      fecha=cls.compr_fecha(vect[0],ini)
      hora=cls.compr_hora(vect[1])
      telefono=cls.compr_telefono(vect[2])
      destino=cls.compr_destino(vect[3])
      try:
         duracion=cls.compr_duracion(vect[4])
      except ValueError: #No contiene una duración, así que debe ser un mensaje
         tipo=cls.compr_tipo(vect[4])
         duracion=0
      else:
         tipo='Llamada'
      coste=cls.compr_coste(vect[5])
      return tuple.__new__(cls,(tipo,fecha,hora,destino,telefono,duracion,coste))

   @classmethod
   def compr_tipo(cls,duracion):
      tipo= [
               'SMS',
               'MMS'
            ]
      try:
        tipo.index(duracion)
      except ValueError:
         raise NotImplementedError, 'No se encuentra el tipo %s. Posiblemente sea un bug de la aplicación.' % duracion
      return duracion

   @classmethod
   def compr_fecha(cls,fecha,ini):
      meses = [
                'Ene.',
                'Feb.',
                'Mar.',
                'Abr.',
                'Mayo.',
                'Jun.',
                'Jul.',
                'Ago.',
                'Sept.',
                'Oct.',
                'Nov.',
                'Dic.'
              ]
      fecha=fecha.split()
      try:
         mes=meses.index(fecha[1])+1
      except ValueError:
         raise NotImplementedError, u'No se encuentra el mes %s. Posiblemente sea un bug de la aplicaci\xf3n.' % fecha[1]
      #Cálculo del año (un poco chapucero: no vale para periodos mayores de un año)
      anno=ini.year
      if mes<ini.month:
         anno+=1
      return datetime(anno,mes,int(fecha[0]))

   @classmethod
   def compr_hora(cls,hora):
      return hora

   compr_destino=compr_hora
   compr_telefono=compr_hora

   @classmethod
   def compr_duracion(cls,duracion):
      return d2s(duracion)

   @classmethod
   def compr_coste(cls,coste):
      return Importe(coste)

   def gtipo(self):
      return self[0]
   tipo=property(gtipo,None,None,'Tipo de la llamada')

   def gfecha(self):
      return self[1]
   fecha=property(gfecha,None,None,'Fecha de la llamada')

   def ghora(self):
      return self[2]
   hora=property(ghora,None,None,'Hora en que se produjo la llamada')

   def gdestino(self):
      return self[3]
   destino=property(gdestino,None,None,'Tipo de destino de la llamda')

   def gtelefono(self):
      return self[4]
   telefono=property(gtelefono,None,None,'Numero de teléfono de la llamada')

   def gduracion(self):
      return self[5]
   duracion=property(gduracion,None,None,'Duración de la llamada')

   def gcoste(self):
      return self[6]
   coste=property(gcoste,None,None,'Coste de la llamada')


class Importe(float):
   "Clase para almacenar un importe con tres decimales"
   def __new__(cls,cantidad):
      return float.__new__(cls,cantidad)

   def __repr__(self):
      return "%.3f" % self

class Listado(list):
   "Listado de todas las llamadas"
   def __init__(self,v,ini,fin):
      list.__init__(self,v)
      self.ini=ini
      self.fin=fin

   def append(self,x):
      if x.__class__.__name__!='Llamada':
         raise ValueError, 'El elemento no es una llamada'
      else:
         list.append(self,x)

   @staticmethod
   def s2d(duracion):
      return s2d(duracion)

   @staticmethod
   def d2s(duracion):
      return d2s(duracion)

   def duracion_total(self):
      return Listado.s2d(sum([x.duracion for x in self if x.tipo=='Llamada']))

   def num_llamadas(self):
      return len([x for x in self if x.tipo=='Llamada'])

   def num_sms(self):
      return len([x for x in self if x.tipo=='SMS'])

   def num_mms(self):
      return len([x for x in self if x.tipo=='MMS'])

###
# main
###

def help():
   "Ayuda"
   return __doc__+u"""

Modos de empleo:
   %s [opciones]
   donde las opciones pueden ser:

-u <email>, --user <email>                   Email que sirve para identificar al usuario.
-p <password>, --password <password>         Clave de acceso.
-n <n\xfamero>, --numero <n\xfamero>               N\xfamero sobre el que se desea realizar
                                             la consulta.
-i <dd/mm/aaaa>, --desde <dd/mm/aaaa>        Fecha desde la que se quieren comprobar
                                             las llamadas.
-f <dd/mm/aaaa>, --hasta <dd/mm/aaaa>        Fecha hasta la que se quieren comprobar
                                             las llamadas.
-M <mm[/aaaa]>, --mes <mm[/aaaa]>            Mes de facturaci\xf3n.
-m <m\xf3dulo>, --modulo <m\xf3dulo>               M\xf3dulo que se desea utilizar.
-h , --help                                  Muestra este mensaje de ayuda.

Si no se especifican fechas, se entiende que se desea consultar el mes actual.
"""

def conv_fecha(fecha):
   "Convierte la fecha dd/mm/aaaa a formato de datetime"
   a=fecha.split('/')
   a.reverse()
   try:
      return datetime(*[int(x) for x in a])
   except:
      raise ValueError, 'La fecha %s es incorrecta.' % fecha

def conv_mes(mes):
   "Convierte el mes mm[/aaaa] en mm/aaaa"
   try:
      a=[int(x) for x in mes.split('/')]
   except ValueError:
      raise ValueError, u'El mes no est\xe1 bien expresado'

   if a[0]<1 or a[0]>12:
      raise ValueError, u'El mes no est\xe1 bien expresado'

   if len(a)==1:
      mes=int(time.strftime('%m'))
      anno=int(time.strftime('%Y'))
      if mes<a[0]:
         anno-=1
      a.append(anno)

   if len(a)>2:
      raise ValueError, u'El mes no est\xe1 bien expresado'

   return '/'.join([str(x) for x in a])

def argumentos():
   import getopt

   global user
   global pwd
   global ini
   global fin
   global num
   global modulo
   global mes

   try:
      opts, args = getopt.getopt(sys.argv[1:], "hu:p:i:f:n:m:M:", ["help", "user=","password=","desde=","hasta=","numero=","modulo=","mes="])
   except getopt.GetoptError,err:
      sys.stderr.write(help())
      sys.stderr.write(str(err) + '\n')
      sys.exit(2)

   for o,a in opts:
      if o in ('-u','--user'):
         user = a
      elif o in ('-p','--password'):
         pwd = a
      elif o in ('-i','--desde'):
         conv_fecha(a)
         ini = a
      elif o in ('-f','--hasta'):
         conv_fecha(a)
         fin = a
      elif o in ('-n','--numero'):
         num = unicode(a)
      elif o in ('-m','--modulo'):
         modulo = a
      elif o in ('-M','--mes'):
         mes = conv_mes(a)
      elif o in ('-h','--help'):
         print help()
         sys.exit(0)



   #Comprobación de las fechas de inicio y fin:
   if mes is None:
      if ini is None and fin is None: # Mes actual
         ini=time.strftime('01/%m/%Y') #o sea, el primer dia del mes presente
         fin=time.strftime('%d/%m/%Y') #o sea, hoy
      elif ini is None or fin is None:
         raise ValueError, u'Indique un mes, o bien una fecha de inicio y otra de final.'
   else:
      ini=conv_fecha('01/' + mes)
      mes=ini.month+1
      if mes==13:
         mes,anno=1,ini.year+1
      else:
         anno=ini.year
      fin=conv_fecha('01/'+ str(mes) + '/' + str(anno))
      fin-=timedelta(days=1)
      ini=ini.strftime('%d/%m/%Y')
      fin=fin.strftime('%d/%m/%Y')

   if modulo is None:
      #Módulo por defecto
      modulo='coste'

   if user is None or pwd is None or num is None:
      raise ValueError, u'Son indispesables los datos de usuario, clave, n\xfamero de telefono y m\xf3dulo que se desea usar.'

if __name__=='__main__':

   import os
   import time
   import sys


   bindir=os.path.dirname(sys.argv[0])
   modulesdir=os.path.join(bindir,'modules')
   if os.path.isdir(modulesdir):
      sys.path.append(modulesdir)
   else:
      sys.stderr.write('El directorio de modulos no existe.\n')
      sys.exit(255)

   # Buscar cómo se hace para que funcione en windows
   homepath=os.path.expanduser('~')

   user=None
   pwd=None
   num=None
   ini=None
   fin=None
   modulo=None
   mes=None

   #Fichero de configuración: util para guardar el usuario y la contraseña
   try:
      execfile(path.join(homepath,'.pepephone.conf'))
   except IOError:
      try:
         execfile(os.path.join(bindir,'pepephone.conf'))
      except IOError:
         pass

   argumentos()

   try:
      exec "from %s import Consulta" % modulo
   except ImportError:
      sys.stderr.write('El m\xf3dulo %s parece no existir o no estar bien definido.\n' % modulo)
      sys.exit(254)

   #Se comprueba si hay una redefinición de la clase Llamada
   try:
      exec "from %s import Llamada" % modulo
   except ImportError:
      # No pasa nada: se usa el módulo definido aquí
      pass

   pepephone=MiPepephone(user,pwd)
   if num not in pepephone.nums:
      raise ValueError, u'El n\xfaumero %s no parece ser suyo' % num

   detalle = pepephone.llamadas(num,ini,fin)
   ini,fin=conv_fecha(ini),conv_fecha(fin)
   llamadas=Consulta([],ini,fin)
   for x in detalle:
      llamadas.append(Llamada(x,ini))
   llamadas.output()
