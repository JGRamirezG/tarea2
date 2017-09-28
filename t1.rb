require'httparty'
include HTTParty
URL='https://sepa.utem.cl/rest/api/v1/'
AUTH={username: 'CcRv0U25NL', password: '062cf7c821a21e1170bc6c14d0c7270f'}
def tarea(rut)
	a=''
    uri='docencia/estudiantes/'+rut.to_s+'/asignaturas' 
    respuesta = HTTParty.get(URI.encode(URL+uri), basic_auth: AUTH)
    if respuesta.code == 200
		puts 'Logeo Exitoso'
		respuesta.each do |i|
			a=i['estudiante']['apellidos']
		end
    end
    if respuesta.code == 403
        puts "Error 403"
    end
    if respuesta.code == 404
		puts "Error 404"
    end
    if respuesta.code == 500
		puts "Error 500"
    end
    #Notas Ramos 2016
    if respuesta.code == 200
		File.open("#{a}","a+") do |cualquiera|
			cualquiera.puts("Alumno: #{a}")
			cualquiera.puts("-Notas Ramos 2016: ")
			respuesta.each do |ano|
				if ano['curso']['anio']==2016
					cualquiera.puts ("#{ano['curso']['asignatura']['nombre']}")
					cualquiera.puts ("#{ano['nota']}")
				end
			end
		end
		
    end
    promg=[]
    cont=0
    sumageneral=0
    #promedio general
    if respuesta.code == 200
	  File.open("#{a}","a+") do |cualquiera2|
		cualquiera2.puts("-Promedio general: ")
		respuesta.each do |notas|
			promg<<notas['nota']
			cont+=1
		end
		promg.each do |promediog|
			sumageneral=promediog+sumageneral
		end
		promediogeneral=sumageneral/cont
		cualquiera2.puts ("#{promediogeneral}")
	  end
    end
    #promedio por año y por semestre
    anoi=respuesta[0]['curso']['anio']
    anof=respuesta[cont-1]['curso']['anio']
    dif=(anof-anoi)+1
    anios=[]
    i=0
    anios[0]=anoi
    i=1
    while i<dif do
		anios[i]=anios[i-1]+1
		i+=1
	end
	anios[i]=anof
	i=0
	suma1=0.0
	suma2=0.0
	cont1=0.0
	cont2=0.0
	cont3=0
    if respuesta.code == 200
	  File.open("#{a}","a+") do |cualquiera3| #escribir en archivo
		cualquiera3.puts("-Promedio por semestre: ")  #escribir en archivo
		respuesta.each do |notas2|  #saca la wea
			cont3+=1
				if(notas2['curso']['anio']== anios[i])
						if(notas2['curso']['semestre'] == 1)
						suma1=suma1+notas2['nota']
						cont1+=1.0
						end
						if(notas2['curso']['semestre']==2)
						suma2=suma2+notas2['nota']
						cont2+=1.0
						end
				end
				if(notas2['curso']['anio']!= anios[i])
					cualquiera3.puts("anio: #{anios[i]} semestre 1")
					cualquiera3.puts("#{suma1/cont1}")
					cualquiera3.puts("anio: #{anios[i]} semestre 2")
					cualquiera3.puts("#{suma2/cont2}")
					i+=1; cont1=0; cont2=0; suma1=0; suma2=0
				end
				if(notas2['curso']['anio']== anios[i] && (cont)==cont3 && notas2['curso']['semestre'] == 1)
					cualquiera3.puts("anio: #{anios[i]} semestre 1")
					cualquiera3.puts("#{suma1/cont1}")
					i+=1; cont1=0; cont2=0; suma1=0; suma2=0
				end
				if(notas2['curso']['anio']== anios[i] && (cont)==cont3 && notas2['curso']['semestre'] == 2)
					cualquiera3.puts("anio: #{anios[i]} semestre 2")
					cualquiera3.puts("#{suma2/cont2}")
					i+=1; cont1=0; cont2=0; suma1=0; suma2=0
				end
				
		 end
	   end
    end
end

puts ('Ingresar RUT')
tarea(gets.chomp)


