io = require('socket.io')(6000)
population = process.argv[2]
freq_per = process.argv[3]
freq_ph_usage_per = process.argv[4]
stay_time_per = process.argv[5]
pop_limit_per = process.argv[6]

if !population or !freq_per or !freq_ph_usage_per or !stay_time_per or !pop_limit_per
  console.log "Argument/s undefined."
  console.log "Example usage: node index.js 12 32,23,45 22,33,45 12,13,75 32,23,45"
  process.exit -1

hml_freq = (Math.floor Number(num)*0.01*population for num in freq_per.split(','))
hml_freq_ph_usage = (Math.floor Number(num)*0.01*population for num in freq_ph_usage_per.split(','))
hml_stay_time = (Math.floor Number(num)*0.01*population for num in stay_time_per.split(','))
hml_pop_limit = (Math.floor Number(num)*0.01*population for num in pop_limit_per.split(','))

hml_pop_limit[1]+=population- hml_pop_limit.reduce (a,b)->a+b
hml_stay_time[1]+=population- hml_stay_time.reduce (a,b)->a+b
hml_freq_ph_usage[1]+=population- hml_freq_ph_usage.reduce (a,b)->a+b
hml_freq[1]+=population- hml_freq.reduce (a,b)->a+b


class Packet
  constructor: (@smac, @dmac, @ip, @port, @cell_id, @mcc, @mnc, @lac, @service)->

class Person
  state:'present'
  ###
    mac= mac address of the phone of the user
    frequency= times per day the user visits
    freq_ph_usage= times per visit the user operates phone
    stay_time= time in minutes the user stays at the place
    pop_limit= If the count of people at the place is above this number, the user
               will leave the place, or won't visit.
  ###
  constructor: (@mac, @frequency, @freq_ph_usage, @stay_time, @pop_limit)->

  use_phone:()->
    console.log "#{mac} used phone"

users=[]
for num in [1..Number(population)]
  mac=require('crypto').createHash('md5').update("#{num}").digest("hex")
  frequency=0
  freq_ph_usage=0
  stay_time=0
  pop_limit=0

  if hml_freq[0]
    frequency=Math.floor((Math.random() * 4) + 1)
    hml_freq[0]--
  else if hml_freq[1]
    frequency=Math.floor((Math.random() * 2) + 1)
    hml_freq[1]--
  else if hml_freq[2]
    frequency=Math.floor((Math.random() * 1) + 1)
    hml_freq[2]--

  if hml_freq_ph_usage[0]
    freq_ph_usage=Math.floor((Math.random() * 8) + 2)
    hml_freq_ph_usage[0]--
  else if hml_freq_ph_usage[1]
    freq_ph_usage=Math.floor((Math.random() * 4) + 3)
    hml_freq_ph_usage[1]--
  else if hml_freq_ph_usage[2]
    freq_ph_usage=Math.floor((Math.random() * 1) + 2)
    hml_freq_ph_usage[2]--

  if hml_stay_time[0]
    stay_time=Math.floor((Math.random() * 45) + 15)
    hml_stay_time[0]--
  else if hml_stay_time[1]
    stay_time=Math.floor((Math.random() * 25) + 15)
    hml_stay_time[1]--
  else if hml_stay_time[2]
    stay_time=Math.floor((Math.random() * 5) + 15)
    hml_stay_time[2]--

  if hml_pop_limit[0]
    pop_limit=Math.floor((Math.random() * 15) + 5)
    hml_pop_limit[0]--
  else if hml_pop_limit[1]
    pop_limit=Math.floor((Math.random() * 7) + 7)
    hml_pop_limit[1]--
  else if hml_pop_limit[2]
    pop_limit=Math.floor((Math.random() * 2) + 4)
    hml_pop_limit[2]--

  users.push new Person(mac,frequency,freq_ph_usage,stay_time,pop_limit)


for user in users
  console.log user
