#!/usr/bin/env python
#vim: encoding:iso-8859-15

from pepephone import Listado
from pepephone import Importe

class Consulta(Listado):
   """Clase que define la consulta que se quiere realizar
      sobre las llamadas de pepephone, Debe constar al menos
      de un método llamado output"""

   def output(self):
      output="pepephone.csv"
      fic=open(output,'w')
      fic.write('Tipo;Fecha;Hora;Telefono;Red Destino;Duracion (s);Coste\n')
      for x in self:
         fic.write(';'.join([x.tipo,x.fecha.strftime('%d/%m/%Y'),x.hora,x.telefono,x.destino,str(x.duracion),str(x.coste)])+'\n')
      fic.close()
      print 'Consulte el fichero %s' % output
