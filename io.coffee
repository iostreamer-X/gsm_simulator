console.log 'Loading data...'
fs = require 'fs'
cell_towers = require './cell_towers.json'
console.log 'Complete'

class Person
  constructor:(@id,@zone)->

  work_call: 8
  home_call: 4
  try_call:(i)->
    if 8*60 < i < 19*60
      if @work_call isnt 0 and i%70 is 0
        @work_call--
        wr=JSON.stringify {id:@id, time:i, tower:home_to_work[person_to_home[@id].id]}
        fs.appendFile "packets.txt",wr+"\n",(err)->
        #console.log {id:@id, time:i, tower:home_to_work[person_to_home[@id].id]}
    if 20*60 < i < 1440
      if @home_call isnt 0 and i%35 is 0
        @home_call--
        wr=JSON.stringify {id:@id, time:i, tower:person_to_home[@id]}
        fs.appendFile "packets.txt",wr+"\n",(err)->
        #console.log {id:@id, time:i, tower:person_to_home[@id]}
m = (domain,range)->
  fn={}
  for elem in domain
    fn[elem.id]=range[Math.round Math.random()*range.length]
  fn

jsonconcat = (o1, o2) ->
  for key of o2
    o1[key] = o2[key]
  o1

getRandomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min


Object::c = (arg)->
  jsonconcat(@,arg)

z_t = (zone)->
  (tower for tower in cell_towers when tower.zone is zone)

z_p = (zone)->
  (person for person in people when person.zone is zone)


for tower in cell_towers
  if tower.lat>28.4041 and tower.lat<28.6119 and tower.lon>77.11156 and tower.lon<77.34496
    tower['zone']='s'
  if tower.lat>28.48175 and tower.lat<28.67243 and tower.lon>76.83782 and tower.lon<77.20409
    tower['zone']='sw'
  if tower.lat>28.64772 and tower.lat<28.78722 and tower.lon>77.16798 and tower.lon<77.25491
    tower['zone']='n'
  if tower.lat>28.66673 and tower.lat<28.88284 and tower.lon>76.9433 and tower.lon<77.22537
    tower['zone']='nw'
  if tower.lat>28.57525 and tower.lat<28.67766 and tower.lon>77.2478 and tower.lon<77.34488
    tower['zone']='e'
  if tower.lat>28.60701 and tower.lat<28.70129 and tower.lon>76.95499 and tower.lon<77.17973
    tower['zone']='w'
  if tower.lat>28.66252 and tower.lat<28.78588 and tower.lon>77.21841 and tower.lon<77.33527
    tower['zone']='ne'
  if tower.lat>28.61861 and tower.lat<28.66138 and tower.lon>77.1787 and tower.lon<77.26215
    tower['zone']='c'


args = process.argv.slice 2
population = Number args[0]
people=[]

nw = Math.round getRandomInt(35,40)*0.01*Math.floor 21.79*0.01*population
ne = Math.round getRandomInt(10,25)*0.01*Math.floor 13.38*0.01*population
w = Math.round getRandomInt(10,25)*0.01*Math.floor 15.2*0.01*population
c = Math.round getRandomInt(35,40)*0.01* Math.floor 3.45*0.01*population
e = Math.round getRandomInt(35,40)*0.01*Math.floor 10.19*0.01*population
sw = Math.round getRandomInt(35,40)*0.01*Math.floor 13.68*0.01*population
s = Math.round getRandomInt(35,40)*0.01*Math.floor 16.32*0.01*population
n = Math.round getRandomInt(35,40)*0.01* Math.floor 5.27*0.01*population

console.log 'Simulation variables:'
console.log "Population: #{people.length}"
console.log "Population in nw: #{Math.floor 21.79*0.01*population}. Working population: "+nw
console.log "Population in ne: #{Math.floor 13.38*0.01*population}. Working population: "+ne
console.log "Population in w: #{Math.floor 15.2*0.01*population}. Working population: "+w
console.log "Population in c: #{Math.floor 3.45*0.01*population}. Working population: "+c
console.log "Population in e: #{Math.floor 10.19*0.01*population}. Working population: "+e
console.log "Population in sw: #{Math.floor 13.68*0.01*population}. Working population: "+sw
console.log "Population in s: #{Math.floor 16.32*0.01*population}. Working population: "+s
console.log "Population in n: #{Math.floor 5.27*0.01*population}. Working population: "+n

for num in [0..population-1]
  if nw
    person=new Person(num,'nw')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    nw--
  else if ne
    person=new Person(num,'ne')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    ne--
  else if n
    person=new Person(num,'n')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    n--
  else if sw
    person=new Person(num,'sw')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    sw--
  else if s
    person=new Person(num,'s')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    s--
  else if c
    person=new Person(num,'c')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    c--
  else if w
    person=new Person(num,'w')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    w--
  else if e
    person=new Person(num,'e')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    e--

home_to_work = m(z_t('nw'),z_t('sw')).c m(z_t('sw'),z_t('nw')).c m(z_t('e'),z_t('sw')).c m(z_t('s'),z_t('c')).c m(z_t('n'),z_t('sw')).c m(z_t('c'),z_t('sw')).c m(z_t('sw'),z_t('c')).c m(z_t('e'),z_t('c')).c m(z_t('ne'),z_t('n')).c m(z_t('w'),z_t('sw'))
person_to_home = m(z_p('nw'),z_t('nw')).c m(z_p('sw'),z_t('sw')).c m(z_p('e'),z_t('e')).c m(z_p('s'),z_t('s')).c m(z_p('n'),z_t('n')).c m(z_p('c'),z_t('c')).c m(z_p('w'),z_t('w')).c m(z_p('ne'),z_t('ne'))

child_process = require 'child_process'
child_process.exec "rm packets.txt",(e,o,se)->
  console.log 'Writing packets to packets.txt...'
  setInterval ->
    for i in [1..24*60]
      for person in people
        person.try_call i
    for person in people
      person.work_call=getRandomInt 3,8
      person.home_call=getRandomInt 1,4

  ,100
