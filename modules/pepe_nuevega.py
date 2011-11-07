#!/usr/bin/env python
#vim: encoding:iso-8859-15

from coste import td, Consulta as ConsultaG
from pepephone import Llamada as LlamadaG

class Llamada(LlamadaG):
   u"""Redefinici\xf3 del m\xe9todo Llamada para
       definir la tarifa"""

   coste_sms      = 0.09
   coste_mms      = 0.50 # Ni idea de cuánto es en realidad
   coste_establ   = 0.00
   coste_min1     = 0.084
   coste_min2     = 0.084
   seg_cam        = 210 # 3 minutos y medio

   def gcoste(self):
      if self.tipo=='SMS':
         return Llamada.coste_sms
      elif self.tipo=='MMS':
         return Llamada.coste_mms
      elif self.tipo=='Llamada':
         if self.destino=='Informacion':
            coste_llamada=0
         elif self.destino=='900':
            coste_llamada=0
         else: #Hay otros muchos casos: extranjero, números 901, 902, etc,
            if self.duracion<=Llamada.seg_cam:
               coste_llamada=td(Llamada.coste_establ+Llamada.coste_min1/60*self.duracion)
            else:
               coste_llamada=td(Llamada.coste_establ+Llamada.coste_min1/60*Llamada.seg_cam+Llamada.coste_min2/60*(self.duracion-Llamada.seg_cam))
         return coste_llamada
   coste=property(gcoste,None,None,'Coste de la llamada')

class Consulta(ConsultaG):
   # Aquí podrían redefinirse los gastos totales en llamadas,
   # sms, si la tarifa no fuese exactamente la suma de ellos.
   # Por ejemplo, consumos mínimos, regalo de sms, etc.
   pass
