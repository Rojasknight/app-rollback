#!/bin/bash

#Destinity path
RE=...
#Script path
RS=...
#Processed path
NR=...

strFechaHora=$( date +%Y%m%d-%T )
strFecha=`date +"%Y%m%d"`

_LOG_START() {
        #White text Light Green Highlight
        echo -e "\e[1;37;42m$1\e[0m"
}
_LOG_INFO() {
        #Green text bold No Highlight
        echo -e "\e[3;32;40m$1\e[0m"
}

_LOG_STOP() {
        #White text Red Highlight
        echo -e "\e[1;37;41m$1\e[0m"
}

_LOG_INFO "---------------------------------------------------------"
_LOG_START "       1.   MOVIENDO BACKUP A LA RUTA DESTINO                   "
_LOG_INFO "---------------------------------------------------------"

cd $RE/backup
_LOG_INFO "---------------------------------------------------------"
_LOG_START "     LISTANDO BACKUP DESDE LA RUTA DE BACKUPS               "
_LOG_INFO "---------------------------------------------------------"
ls -tr | tail -n 1 | grep "backup"

_LOG_INFO "---------------------------------------------------------"
_LOG_START "    MOVIENDO BACKUPS A LA RUTA DEL DESTINO     "
_LOG_INFO "---------------------------------------------------------"
ls -tr | tail -n 1 | grep "backup" | xargs -I{} cp {} $RE

_LOG_INFO "---------------------------------------------------------"
_LOG_START "    LISTANDO BACKUP EN LA RUTA DESTINO      "
_LOG_INFO "---------------------------------------------------------"
cd $RE
ls *.zip

_LOG_INFO "---------------------------------------------------------"
echo "    DESCOMPRIMIENDO BACKUP EN LA RUTA DESTINO      "
_LOG_INFO "---------------------------------------------------------"
unzip ./backup*.zip
rm ./backup*.zip



_LOG_INFO "---------------------------------------------------------"
_LOG_START "INICIANDO VALIDACION DE PAQUETES .ZIP"
_LOG_INFO "---------------------------------------------------------"
sleep 2

ls -lrt *.zip | awk '{print $9}'
ls -lrt *.zip | awk '{print $9}' > $RS/lista_arc

while read LINE ; do
        if [[ -z $LINE ]]; then
            echo "NO EXISTEN ARCHIVOS .ZIP PARA PROCESAR EN LA RUTA, POR FAVOR VALIDE."
        else
                   _LOG_INFO "---------------------------------------------------------"
                   _LOG_START "INICIA EJECUCION DE IMPORTACION DE PAQUETE DE CONFIGURACIONES"
                   _LOG_INFO "---------------------------------------------------------"
                    sleep 3

                   _LOG_INFO "---------------------------------------------------------"
                   _LOG_START "*******EJECUCION DEL IMPORT DE PAQUETE $LINE**********"
                   _LOG_INFO "---------------------------------------------------------"


                    #/import.sh command > $RS/import_pack.log

                                        #VALIDACION DEL ERROR EN CADA INSTALACION DE PAQUETE
                                        error1=`cat $RS/import_pack.log | grep "Import successful" | wc -l`
                                        cat $RS/import_pack.log

                                        if [ $error1 -ne 0 ] ; then
                                                _LOG_INFO "---------------------------------------------------------"
                                                _LOG_START "IMPORTACION DE ARCHIVO $LINE FINALIZADO"
                                                _LOG_INFO "---------------------------------------------------------"

                                                sleep 2
                                         else
												_LOG_INFO "---------------------------------------------------------"
                                                _LOG_STOP "ERROR EN EL IMPORT DEL PAQUETE $LINE, POR FAVOR VALIDE EL LOG $RS/import_pack.log"
                                                _LOG_INFO "---------------------------------------------------------"
                                                sleep 2
                                        fi

                                           _LOG_INFO "---------------------------------------------------------"
                                           _LOG_START "MOVIENDO EL ARCHIVO .ZIP A LA CARPETA DE PROCESADOS"
                                           _LOG_INFO "---------------------------------------------------------"

                                           mv $RE/$LINE $NR/$LINE"_"$strFechaHora

                   _LOG_INFO "---------------------------------------------------------"
                   _LOG_START "FINALIZA LA EJECUCION DE IMPORTACION DE PAQUETE DE CONFIGURACIONES"
                   _LOG_INFO "---------------------------------------------------------"
                    sleep 3
        fi
done < $RS/lista_arc
				
