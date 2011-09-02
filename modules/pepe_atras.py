#!/usr/bin/env python
#vim: encoding:iso-8859-15

from coste import td, Consulta as ConsultaG
from pepephone import Llamada as LlamadaG

class Llamada(LlamadaG):
   u"""Redefinici\xf3 del m\xe9todo Llamada para
       definir la tarifa"""

   coste_sms    = 0.09
   coste_mms    = 0.29 # Ni idea de cuánto es en realidad
   coste_establ = 0.00
   limite_coste = 0.08
   # Tarifa:
   prec_ini     = 0.12
   prec_fin     = 0.05
   # Esto significa:
   # Primer minuto 12 centimos.
   # Segundo: 11 centimos.
   # ...
   # Octavo minuto: 5 centimos.
   # Resto: 5 centimos.

   @staticmethod
   def sum_aritmetica(a0,n,r):
      "Calcula una suma artimética de término inicial a0, razón r y n términos"
      return (2*a0+(n-1)*r)*n/2.0

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
            mins=self.duracion//60
            segs=self.duracion-mins*60
            min_cambio=(Llamada.prec_ini-Llamada.prec_fin)*100+1
            coste_llamada = Llamada.sum_aritmetica(Llamada.prec_ini,mins,-.01)
            coste_ult_min = Llamada.prec_ini-mins/100.0
            if mins>min_cambio: #El precio se estanca, así que hay que corregir
               coste_llamada += Llamada.sum_aritmetica(0.01,mins-min_cambio,0.01)
               coste_ult_min =  Llamada.prec_fin
            coste_llamada += segs*coste_ult_min/60
            #Hacer es como una doble suma de progresión geométrica.
         return coste_llamada
   coste=property(gcoste,None,None,'Coste de la llamada')

class Consulta(ConsultaG):
   # Aquí podrían redefinirse los gastos totales en llamadas,
   # sms, si la tarifa no fuese exactamente la suma de ellos.
   # Por ejemplo, consumos mínimos, regalo de sms, etc.
   pass
