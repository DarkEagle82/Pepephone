#!/bin/bash
#Handles the keyboard interrupt (control-c)
function ctrl_c
{
    echo "Bye ;)"
    remove_temp_files
    exit 1
}
            
#Trap keyboard interrupt (control-c)
trap ctrl_c SIGINT

#Remove temporary files
function remove_temp_files
{
	if [ -f $RUTA/informe_mensual.txt ]
	then
		rm $RUTA/informe_mensual.txt
	fi
}
         
if [ $# -lt 1 ] || [ $# -gt 3 ] || [ $# -eq 2 ]
then
     echo
     echo "Falta configurar els parametres !"
     echo "Us: $0 fitxer_config.ini [dd] [mm/yyyy]"
     echo
     exit 1
fi

if [ ! -r "$1" ]; then
    echo
    echo "Assegurat que el fitxer de configuracio existeix"
    echo "Us: $0 fitxer_config.ini [dd] [mm/yyyy]"
    echo
    exit 1
fi             

source $1
if [ $UNCONFIG == 1 ]
then
     echo
     echo "Abans has de configurar el $1"
     echo
     exit 1
fi
if [  ${#USUARIO[@]} != ${#TELF[@]} ] || [ ${#USUARIO[@]} != ${#TARIFA[@]} ]
then
     echo "El fitxer de configuraci� no �s correcte, hi ha d'haver el mateix nombre d'usuaris, que de telefons, que de tarifes !!"
     exit 1
fi
# Restem un dia a la fetxa per calcular el consum el dia anterior.
DATEF=`date -d "-1 month" +%m/%Y`

DATEVAR=`date +%m`
if [ $DATEVAR == "01" ]
then
    ANY=`date -d "-1 year" +%Y`
else
ANY=`date +%Y`
fi

# Calculem els dies que te el mes anterior

case "$DATEF" in
   01/$ANY | 03/$ANY | 05/$ANY | 07/$ANY | 08/$ANY | 10/$ANY | 12/$ANY )
   DIA=31
   ;;
   02/$ANY)
   DIA=28
   ;;
   04/$ANY | 06/$ANY | 09/$ANY | 11/$ANY )
   DIA=30 ;;
esac

# Borrem el fitxer d'informe anterior si hi es.

remove_temp_files

# Si li passem dos parametres, els fara servir com a fecha.
# Us: $0 dd mm/yyyy
## dd el maxim de dies del mes
if [ $# -eq 3 ]
        then
        DIA=$2
        DATEF=$3
fi
                
# Encap�alament Correu i assumpte
echo MIME-Version: 1.0 >> $RUTA/informe_mensual.txt
echo Content-type: text\/html\; charset=utf-8 >> $RUTA/informe_mensual.txt
echo subject: Informe MENSUAL per $USUARIO de consum del dia 01/$DATEF al $DIA/$DATEF >> $RUTA/informe_mensual.txt
echo >> $RUTA/informe_mensual.txt
echo \<html\> >> $RUTA/informe_mensual.txt


echo
echo Informe de consum Mensual mes/any: $DATEF
echo Informe de consum Mensual mes/any: $DATEF \<br\> >> $RUTA/informe_mensual.txt
echo
echo \<br\> >> $RUTA/informe_mensual.txt

LINEAS=${#TARIFA[@]}
for ((i=0;i<LINEAS;i++)); do
	# Consulta del moviln
	echo Movil ${USUARIO[$i]}
	echo "************************************" \<br\> >> $RUTA/informe_mensual.txt
	echo \<b\>Movil de ${USUARIO[$i]}\<\/b\> Tarifa Actual: \<font color=\#1E9FEE\>${TARIFA[$i]}\<\/font\>\<br\> >> $RUTA/informe_mensual.txt
	echo "************************************" \<br\> >> $RUTA/informe_mensual.txt
	echo
	echo \<br\> >> $RUTA/informe_mensual.txt
	/usr/bin/python $RUTA2/$PROGRAMA -i 01/$DATEF -f $DIA/$DATEF -n ${TELF[$i]} >> $RUTA/informe_mensual.txt
	echo \<br\> >> $RUTA/informe_mensual.txt
	echo
	
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo Link: \<a href=\"http://www.pepephone.com/tarifamovilonia/\"\>http://www.pepephone.com/tarifamovilonia/\<\/a\> \<br\> >> $RUTA/informe_mensual.txt
	echo Si s\'hagues fet servir la tarifa  \<b\>\<font color=\"blue\"\>VIP\<\/font\>\<\/b\> \(sense establiment\) el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo
	echo \<br\> >> $RUTA/informe_mensual.txt
	/usr/bin/python $RUTA2/$PROGRAMA -i 01/$DATEF -f $DIA/$DATEF -n ${TELF[$i]} -m pepe_vip_noprint >> $RUTA/informe_mensual.txt
	echo \<br\> >> $RUTA/informe_mensual.txt
	echo
	
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo Link: \<a href=\"http://www.pepephone.com/promo/adslzone/\"\>http://www.pepephone.com/promo/adslzone/\<\/a\> \<br\> >> $RUTA/informe_mensual.txt
	echo Si s\'hagues fet servir la tarifa \<b\>\<font color=\"blue\"\>4.5 cent\<\/font\>\<\/b\> el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo
	echo \<br\> >> $RUTA/informe_mensual.txt
	/usr/bin/python $RUTA2/$PROGRAMA -i 01/$DATEF -f $DIA/$DATEF -n ${TELF[$i]} -m pepe5_noprint >> $RUTA/informe_mensual.txt
	echo \<br\> >> $RUTA/informe_mensual.txt
	echo
	
	echo
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo Link: \<a href=\"http://www.pepephone.com/promo/adslzone-pulpopepe/index.html\"\>http://www.pepephone.com/promo/adslzone-pulpopepe/index.html\<\/a\> \<br\> >> $RUTA/informe_mensual.txt
	echo Si s\'hagues fet servir la tarifa  \<b\>\<font color=\"blue\"\>Pulpo Pepe\<\/font\>\<\/b\> el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo
	echo \<br\> >> $RUTA/informe_mensual.txt
	/usr/bin/python $RUTA2/$PROGRAMA -i 01/$DATEF -f $DIA/$DATEF -n ${TELF[$i]} -m pepe_pulpo_noprint >> $RUTA/informe_mensual.txt
	echo \<br\> >> $RUTA/informe_mensual.txt
	echo

	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo Link: \<a href=\"http://www.pepephone.com/promo/movilonia\"\>http://www.pepephone.com/promo/movilonia\<\/a\> \<font color=\"purple\"\>Associada a DADES. +6.9eur\<\/font\>\<br\> >> $RUTA/informe_mensual.txt
	echo Si s\'hagues fet servir la tarifa \<b\>\<font color=\"blue\"\>RATONCITO Y ELEFANTE\<\/font\>\<\/b\> el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo
	echo \<br\> >> $RUTA/informe_mensual.txt
	/usr/bin/python $RUTA2/$PROGRAMA -i 01/$DATEF -f $DIA/$DATEF -n ${TELF[$i]} -m pepe_cobaya_noprint >> $RUTA/informe_mensual.txt	
	echo \<br\> >> $RUTA/informe_mensual.txt
	echo
	
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo Link: \<a href=\"http://www.pepephone.com/tarifamovilonia9/\"\>http://www.pepephone.com/tarifamovilonia9/\<\/a\> \<font color=\"purple\"\>Associada a DADES. +6.9eur\<\/font\>\<br\> >> $RUTA/informe_mensual.txt
	echo Si s\'hagues fet servir la tarifa \<b\>\<font color=\"blue\"\>NUEVEGA Y HABLA\<\/font\>\<\/b\>  \(sense establiment\) el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo
	echo \<br\> >> $RUTA/informe_mensual.txt
	/usr/bin/python $RUTA2/$PROGRAMA -i 01/$DATEF -f $DIA/$DATEF -n ${TELF[$i]} -m pepe_nuevega_noprint >> $RUTA/informe_mensual.txt	
	echo \<br\> >> $RUTA/informe_mensual.txt
	echo
	
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo Link: \<a href=\"http://www.pepephone.com/promo/moviltoday8/\"\>http://www.pepephone.com/promo/moviltoday8/\<\/a\> \<br\> >> $RUTA/informe_mensual.txt
	echo Si s\'hagues fet servir la tarifa \<b\>\<font color=\"blue\"\>MOVIL TODAY\<\/font\>\<\/b\> el gasto hauria sigut de: \<br\> >> $RUTA/informe_mensual.txt
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \<br\> >> $RUTA/informe_mensual.txt
	echo
	echo \<br\> >> $RUTA/informe_mensual.txt
	/usr/bin/python $RUTA2/$PROGRAMA -i 01/$DATEF -f $DIA/$DATEF -n ${TELF[$i]} -m pepe_movil_today_noprint >> $RUTA/informe_mensual.txt	
	echo \<br\> >> $RUTA/informe_mensual.txt
	echo
	
	
	echo \<\/html\> >> $RUTA/informe_mensual.txt
	echo
done	
# Enviament de correu electronic
NUMMAILS=${#CORREO[@]}
for ((i=0;i<NUMMAILS;i++)); do
	cat $RUTA/informe_mensual.txt | /usr/sbin/sendmail ${CORREO[$i]}
done
exit 0
