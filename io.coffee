console.log 'Loading data...'
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
        console.log home_to_work[person_to_home[@id].id]
    if 20*60 < i < 1440
      if @home_call isnt 0 and i%35 is 0
        @home_call--
        console.log person_to_home[@id]
mapper = (domain,range)->
  fn={}
  for i in [0..domain.length-1]
    fn[domain[i].id]=range[Math.round Math.random()*range.length]
  fn

jsonconcat = (o1, o2) ->
  for key of o2
    o1[key] = o2[key]
  o1

getRandomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min


Object.prototype.concat = (arg)->
  jsonconcat(@,arg)

zone_tower = (zone)->
  (tower for tower in cell_towers when tower.zone is zone)

zone_person = (zone)->
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

nw = getRandomInt(35,40)*0.01*Math.floor 21.79*0.01*population
ne = getRandomInt(35,40)*0.01*Math.floor 13.38*0.01*population
w = getRandomInt(35,40)*0.01*Math.floor 15.2*0.01*population
c = getRandomInt(35,40)*0.01* Math.floor 3.45*0.01*population
e = getRandomInt(35,40)*0.01*Math.floor 10.19*0.01*population
sw = getRandomInt(35,40)*0.01*Math.floor 13.68*0.01*population
s = getRandomInt(35,40)*0.01*Math.floor 16.32*0.01*population
n = getRandomInt(35,40)*0.01* Math.floor 5.27*0.01*population

for num in [0..population-1]
  if nw
    person=new Person(num,'nw')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    nw--
  if ne
    person=new Person(num,'ne')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    ne--
  if n
    person=new Person(num,'n')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    n--
  if sw
    person=new Person(num,'sw')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    sw--
  if s
    person=new Person(num,'s')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    s--
  if c
    person=new Person(num,'c')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    c--
  if w
    person=new Person(num,'w')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    w--
  if e
    person=new Person(num,'e')
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4
    people.unshift(person)
    e--

home_to_work = mapper(zone_tower('nw'),zone_tower('sw')).concat mapper(zone_tower('sw'),zone_tower('nw')).concat
mapper(zone_tower('e'),zone_tower('sw')).concat mapper(zone_tower('s'),zone_tower('c')).concat
mapper(zone_tower('n'),zone_tower('sw')).concat mapper(zone_tower('c'),zone_tower('sw')).concat
mapper(zone_tower('sw'),zone_tower('c')).concat mapper(zone_tower('e'),zone_tower('c'))

person_to_home = mapper(zone_person('nw'),zone_tower('nw')).concat mapper(zone_person('sw'),zone_tower('sw')).concat
mapper(zone_person('e'),zone_tower('e')).concat mapper(zone_person('s'),zone_tower('s')).concat
mapper(zone_person('n'),zone_tower('n')).concat mapper(zone_person('c'),zone_tower('c')).concat
mapper(zone_person('w'),zone_tower('w')).concat mapper(zone_person('ne'),zone_tower('n'))

setInterval ->
  for i in [1..24*60]
    for person in people
      person.try_call i
  for person in people
    person.work_call=getRandomInt 1,8
    person.home_call=getRandomInt 1,4

,100
