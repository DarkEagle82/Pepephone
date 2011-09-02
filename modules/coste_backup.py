#!/usr/bin/env python
#vim: encoding:iso-8859-15

from pepephone import Listado

from math import floor
from pepephone import Importe
def td(x,d=3):
   "Extrae los d primeros decimales de un número"
   return Importe(floor(x*10**3)/10**3)

class Consulta(Listado):
   """Clase que define la consulta que se quiere realizar
      sobre las llamadas de pepephone, Debe constar al menos
      de un método llamado output"""

   consumo_minimo = 0

   def gcoste_voz(self):
      if not(hasattr(self,'__coste_voz')):
         self.__coste_voz=sum([x.coste for x in self if x.tipo=='Llamada'])
      return self.__coste_voz
   coste_voz=property(gcoste_voz,None,None,'Consumo en llamadas de voz')

   def gcoste_sms(self):
      if not(hasattr(self,'__coste_sms')):
         self.__coste_sms=sum([x.coste for x in self if x.tipo=='SMS'])
      return self.__coste_sms
   coste_sms=property(gcoste_sms,None,None,'Consumo en mensajes sms')

   def gcoste_mms(self):
      if not(hasattr(self,'__coste_mms')):
         self.__coste_mms=sum([x.coste for x in self if x.tipo=='MMS'])
      return self.__coste_mms
   coste_mms=property(gcoste_mms,None,None,'Consumo en mensajes mms')

   def gcoste_total(self):
      if not(hasattr(self,'__coste_total')):
         self.__coste_total=self.coste_voz+self.coste_sms+self.coste_mms
         if self.__class__.consumo_minimo>self.__coste_total:
            self.__coste_total=self.__class__.consumo_minimo
      return self.__coste_total
   coste_total=property(gcoste_total,None,None,'Consumo total')

   def est_llamadas(self,limi,lims):
      "Número de llamdas de entre limi y lims minutos"
      return len([x for x in self if x.tipo=='Llamada' and x.duracion>=limi*60 and x.duracion<lims*60])

   def output(self):
      print "Resumen:"
      print "--------"
      print '%d llamadas (%s minutos) con un coste de %.3f euros.' % (self.num_llamadas(),self.duracion_total(),self.coste_voz)
      print "%d sms enviados con un coste de %.3f euros." % (self.num_sms(),self.coste_sms)
      print "%d mms enviados con un coste de %.3f euros." % (self.num_mms(),self.coste_mms)
      print "Consumo total: %.2f euros." % self.coste_total
      print
      print "Estadistica de llamadas:"
      print "------------------------"
      print "<1  minuto    %3d" % self.est_llamadas(0,1)
      print "1-2 minutos   %3d" % self.est_llamadas(1,2)
      print "2-4 minutos   %3d" % self.est_llamadas(2,4)
      print "4-5 minutos   %3d" % self.est_llamadas(4,5)
      print ">5 minutos    %3d" % self.est_llamadas(5,100000)
