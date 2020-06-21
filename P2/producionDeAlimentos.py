#DanielLópezAcero
import sys
#import numpy as np
import numpy
#La lectura de datos de datos se hace copiando los datos directamente en la consola pues tenia problemas con la
#consola de python y he tenido que ejecutar el codigo desde Visual Studio Code
#Los datos son el archivo datos.txt

#############################################################################
#   LECTURA DE DATOS:
#############################################################################
datos=input().split()
aceites= int(datos[0])
vegetales=int(datos[1])
noVegetales=int(datos[2])
#Para introducir la tabla la introduciremos 12 cadenas de long aciete
tablauuno=numpy.zeros((12,aceites))
for i in range(12):
    datos=input().split()
    for j in range(aceites):
        tablauuno[i,j]=(int(datos[j]))
#convertin en int la Tabla de precios ya que con numpy los crea como double
tabla=tablauuno.astype(int)
#MiAlmacen inicial
almacenIni=[]
datos=input().split()
for i in range(aceites):
    almacenIni.append(int(datos[i]))
#Valor
datos=input()
valor=datos
#MaxV y MaxN
datos=input().split()
MaxV=int(datos[0])
MaxN=int(datos[1])
#Mcap
datos=input()
Mcap=datos
#CA
datos=input()
CA=datos
#MinD y MaxD
datos=input().split()
MinD=int(datos[0])
MaxD=int(datos[1])
#Durezas:
datos=input().split()
durezas=[]
for i in range(aceites):
    durezas.append(int(datos[i]))
#MinimoBeneficio:
datos=input()
MinB=datos

#############################################################################
#   METODOS:
#############################################################################
def miAlm(i,j):                     #miAlmacen Mes 0 aceite 0 
    return "miAlmacen_"+str(i)+"_"+str(j)
    
def miAlmAux(i):                     #miAlmacen Mes 0 
    return "miAlmacenAux_"+str(i)
    
def compr(i,j):                     #compras Mes 0 aceite 0 
    return "compras_"+str(i)+"_"+str(j)
    
def ref(i,j):                     #refinado  Mes 0 aceite 0 
    return "refinado_"+str(i)+"_"+str(j)

def din(i):                     #dinero Mes 0
    return "dinero_"+str(i)

def CostAlm(i):
    return "costeAlmacenamiento_"+str(i)

def ganado(i):
    return "dineroGanado_"+str(i)

def gastado(i):
    return"dineroGastado_"+str(i)


def setlogic(l):
    return "(set-logic "+ l +")"

def intvar(v):
    return "(declare-fun "+v+" () Int)"

def bool2int(b):
    return "(ite "+b+" 1 0 )"

def addimplies(a1,a2):
    return "(=> "+a1+" "+a2+" )"
def addand(a1,a2):
    return "(and "+a1+" "+a2+" )"
def addor(a1,a2):
    return "(or "+a1+" "+a2+" )"
def addnot(a):
    return "(not "+a+" )"

def addexists(a):
    if len(a) == 0:
        return "false"
    elif len(a) == 1:
        return a[0]
    else :
        x = a.pop()
        return "(or " + x + " " + addexists(a) + " )" 

def addeq(a1,a2):
    return "(= "+a1+" "+a2+" )" 
def addle(a1,a2):
    return "(<= "+a1+" "+a2+" )" 
def addge(a1,a2):
    return "(>= "+a1+" "+a2+" )" 
def addlt(a1,a2):
    return "(< "+a1+" "+a2+" )"
def addgt(a1,a2):
    return "(> "+a1+" "+a2+" )" 

def addplus(a1,a2):
    return "(+ "+a1+" "+a2+" )"

def addminus(a1,a2):
    return "(- "+a1+" "+a2+" )"

def addmulti(a1,a2):
    return "(* "+a1+" "+a2+" )"
    
def adddiv(a1,a2):
    return "(/ "+a1+" "+a2+" )"

def addassert(a):
    return "(assert "+a+" )"

def addassertsoft(a,w):
    return "(assert-soft "+a+" :weight "+ w + " )"

def addsum(a):
    if len(a) == 0:
        return "0"
    elif len(a) == 1:
        return a[0]
    else :
        x = a.pop()
        return "(+ " + x + " " + addsum(a) + " )" 

def checksat():
    print("(check-sat)")
def getobjectives():
    print("(get-objectives)")
def getmodel():
    print("(get-model)")
def getvalue(l):
    print("(get-value " + l + " )")

#############################################################################
# generamos un fichero smtlib2
#############################################################################


print("(set-option :produce-models true)")
print(setlogic("QF_LIA"))


#DECLARACION DE VARIABLES:
    
#Declaracion de COMPRAS
for i in range(12):
    for j in range(aceites):
         print(intvar(compr(i,j)))

#declaramos el DINERO por mes
for i in range(12):
    print(intvar(din(i)))
#Declaracion REFINADO
for i in range(12):
    for j in range(aceites):
        print(intvar(ref(i,j)))
#Declaracion de MI ALMACEN
for i in range(12):
    for j in range(aceites):
        print(intvar(miAlm(i,j)))

for j in range(aceites):
    print(intvar(miAlmAux(j)))


#############################################################################
#ASSERTS:
#############################################################################

#ASIGNAMOS LOS VALORES CORRESPONDIENTES:
#Asignamos el primer mes:
for j in range(aceites):
    print(addassert(addeq(miAlmAux(j),str(almacenIni[j]))))

#Se acaba el año como se empieza:
for j in range(aceites):
    print(addassert(addeq(str(almacenIni[j]),miAlm(11,j))))


#Constraint maximo almacenado
for i in range(12):
    for j in range(aceites):
        print(addassert(addle(miAlm(i,j),Mcap)))


#para el primer mes
for j in range(aceites):
    print(addassert(addeq(miAlm(0,j),addplus(miAlmAux(j),addminus(compr(0,j),ref(0,j))))))

##Mi almacen es igual a mi almacen del mes anterior mas las compras menos lo refinado:
#constraint forall(i in 2..12) ( forall(j in 1..aceites) (miAlmacen[i,j]=miAlmacen[i-1,j]+compras[i,j]-refinado[i,j]));
for i in range(1,12):
    for j in range(aceites):
        print(addassert(addeq(miAlm(i,j),addplus(miAlm(i-1,j),addminus(compr(i,j),ref(i,j))))))

  
#No se puede refinar mas de lo que hay en mi Almacen
for i in range(12):
    for j in range(aceites):
        print(addassert(addle(ref(i,j),miAlm(i,j))))

#No se puede refinar mas de lo maximo:
#Vegetal:
for i in range(12):
    sum=[]
    for j in range(vegetales):
        sum.append(ref(i,j))
        print(addassert(addle(addsum(sum),str(MaxV))))
#NoVegetal:
for i in range(12):
    sum1=[]
    for j in range(vegetales,aceites):
        sum1.append(ref(i,j))
        print(addassert(addle(addsum(sum1),str(MaxN))))


#no se puede refinar negativo
for i in range(12):
    for j in range(aceites):
        print(addassert(addge(ref(i,j),str(0))))
#no se puede comprar negativamente:
for i in range(12):
    for j in range(aceites):
        print(addassert(addge(compr(i,j),str(0))))

#no se puede tener negativo en mi almacen:       
for i in range(12):
    for j in range(aceites):
        print(addassert(addge(miAlm(i,j),str(0))))


#constraint forall(i in 1..12) (sum(j in 1..aceites) (refinado[i,j]*durezas[j]) / sum(x in 1..aceites)(refinado[i,x])> MinD 
# /\ sum(j in 1..aceites) (refinado[i,j]*durezas[j]) / sum(x in 1..aceites)(refinado[i,x])< MaxD);
#Para expresar la division hay que expresarlo como multipicacion
def sumdurezasrefmedia(i):
    su=[]
    for j in range(aceites):   
        su.append(addmulti(ref(i,j),str(durezas[j])))  
    return addsum(su)

def sumRefporMaxD(i):
    su=[]
    for j in range(aceites):
        su.append(ref(i,j))
    return addmulti(str(MaxD),addsum(su))

def sumRefporMinD(i):
    su=[]
    for j in range(aceites):
        su.append(ref(i,j))
    return addmulti(str(MinD),addsum(su))

for i in range(12):
    print(addassert(addand(addge(sumdurezasrefmedia(i),sumRefporMinD(i)),addle(sumdurezasrefmedia(i),sumRefporMaxD(i)))))


#El beneficio:
#function var int:DineroGastado(var int:mes)= (sum(j in 1..aceites) ((miAlmacen[mes,j]*CA) + (compras[mes,j]*tabla[mes,j]) ));
#function var int:DineroGanado(var int:mes)=(sum(j in 1..aceites) (refinado[mes,j]*Valor) );
#constraint forall(i in 2..12) ( dinero[i] = dinero[i-1] + DineroGanado(i)-DineroGastado(i));

def costeAlm(i):
    su=[]
    for j in range(aceites):
        su.append(miAlm(i,j))
    return addmulti(CA,addsum(su))
  
def dineroDeCompras(i):
    su=[]
    for j in range(aceites):
        su.append(addmulti(compr(i,j),str(tabla[i,j])))
    return addsum(su)

def dineroGanado(i):
    su=[]
    for j in range(aceites):
        su.append(ref(i,j))
    return addmulti(valor,addsum(su))

def DineroGastado(i):
    return addplus(dineroDeCompras(i),costeAlm(i))

for i in range(1,12):
    print(addassert(addeq(din(i),addplus(din(i-1),addminus(dineroGanado(i),DineroGastado(i))))))


#Para el primer mes:
print(addassert(addeq(din(0),addminus(dineroGanado(0),DineroGastado(0)))))

#constraint dinero[12] > MinB;
print(addassert(addgt(din(11),MinB)))

#No dinero negativo el primer mes
print(addassert(addge(din(0),str(0))))


checksat()

#Get results:
for i in range(12):
    for j in range(aceites):
        getvalue("("+ ref(i,j)+")")


for i in range(12):
    for j in range(aceites):
        getvalue("("+ compr(i,j)+")")


for i in range(12):
    for j in range(aceites):
        getvalue("("+ miAlm(i,j)+")")


for i in range(12):
    getvalue("("+ din(i)+")")

exit(0)