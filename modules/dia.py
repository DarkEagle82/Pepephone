#!/usr/bin/env python
#vim: encoding:iso-8859-15

from pepephone import Listado
from datetime import datetime,timedelta

class Consulta(Listado):
   """Clase que define la consulta que se quiere realizar
      sobre las llamadas de pepephone, Debe constar al menos
      de un método llamado output"""
   def duracion_por_dia(self):
      res=[]
      un_dia=timedelta(days=1)
      fecha=self.ini
      if self:
         while fecha<self[0].fecha:
            res.append((fecha,0))
            fecha+=un_dia
         fecha=self[0].fecha
         duracion=0
         for x in self:
            if x.fecha==fecha:
               duracion+=x.duracion
            else:
               res.append((fecha,duracion))
               while True:
                  fecha+=un_dia
                  if fecha==x.fecha:
                     break
                  res.append((fecha,0))
               fecha=x.fecha
               duracion=x.duracion
         res.append((fecha,duracion))
      while fecha<self.fin:
         fecha+=un_dia
         res.append((fecha,0))
      return res

   def output(self):
      print '%s minutos en %d llamadas.' % (self.duracion_total(),self.num_llamadas())
      print "Desglose diario:"
      for d in self.duracion_por_dia():
         print '%-15s %s' % (d[0].strftime('%d/%m/%Y'),Consulta.s2d(d[1]))
