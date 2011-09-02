#!/usr/bin/env python
#vim: encoding:iso-8859-15

from coste_noprint import td, Consulta as ConsultaG
from pepephone import Llamada as LlamadaG

class Llamada(LlamadaG):
   u"""Redefinici\xf3 del m\xe9todo Llamada para
       definir la tarifa"""

   coste_sms    = 0.09
   coste_mms    = 0.29 # Ni idea de cu�nto es en realidad
   coste_establ = 0.15
   coste_minuto = 0.045

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
         else: #Hay otros muchos casos: extranjero, n�meros 901, 902, etc,
            coste_llamada=td(Llamada.coste_establ+Llamada.coste_minuto/60*self.duracion)
         return coste_llamada
   coste=property(gcoste,None,None,'Coste de la llamada')

class Consulta(ConsultaG):
   # Aqu� podr�an redefinirse los gastos totales en llamadas,
   # sms, si la tarifa no fuese exactamente la suma de ellos.
   # Por ejemplo, consumos m�nimos, regalo de sms, etc.
   pass
