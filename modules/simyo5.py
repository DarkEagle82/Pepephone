#!/usr/bin/env python
#vim: encoding:iso-8859-15

from coste import td, Consulta as ConsultaG
from pepephone import Llamada as LlamadaG

class Llamada(LlamadaG):
   u"""Redefinici\xf3 del m\xe9todo Llamada para
       definir la tarifa"""

   coste_sms    = 0.09
   coste_mms    = 0.29 # Ni idea de cuánto es en realidad
   coste_establ = 0.15
   coste_minuto = 0.08
   seg_grat     = 600  #Segundos gratuitos entre simyos.

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
            if self.destino=='EPLUS': # Simyo
               coste_llamada=Llamada.coste_establ
               if self.duracion>Llamada.seg_grat:
                  coste_llamada+=Llamada.coste_minuto/60*(self.duracion-Llamada.seg_grat)
            else:
               coste_llamada=Llamada.coste_establ+Llamada.coste_minuto/60*self.duracion
         return td(coste_llamada)
   coste=property(gcoste,None,None,'Coste de la llamada')

class Consulta(ConsultaG):
   # Aquí podrían redefinirse los gastos totales en llamadas,
   # sms, si la tarifa no fuese exactamente la suma de ellos.
   # Por ejemplo, consumos mínimos, regalo de sms, etc.
   consumo_minimo = 7
