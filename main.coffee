ws = require 'nodejs-websocket'
#heapdump = require 'heapdump'
population = process.argv[2]
freq_per = process.argv[3]
freq_ph_usage_per = process.argv[4]
stay_time_per = process.argv[5]
pop_limit_per = process.argv[6]

if !population or !freq_per or !freq_ph_usage_per or !stay_time_per or !pop_limit_per
  console.log "Argument/s undefined."
  console.log "Example usage: node --expose-gc index.js 12 32,23,45 22,33,45 12,13,75 32,23,45"
  process.exit -1

process.on 'SIGUSR2', ()->
  console.log 'gc'
  gc()

server = ws.createServer((conn) ->
  console.log 'New connection'
  hml_freq = (Math.floor Number(num)*0.01*population for num in freq_per.split(','))
  hml_freq_ph_usage = (Math.floor Number(num)*0.01*population for num in freq_ph_usage_per.split(','))
  hml_stay_time = (Math.floor Number(num)*0.01*population for num in stay_time_per.split(','))
  hml_pop_limit = (Math.floor Number(num)*0.01*population for num in pop_limit_per.split(','))

  hml_pop_limit[1]+=population- hml_pop_limit.reduce (a,b)->a+b
  hml_stay_time[1]+=population- hml_stay_time.reduce (a,b)->a+b
  hml_freq_ph_usage[1]+=population- hml_freq_ph_usage.reduce (a,b)->a+b
  hml_freq[1]+=population- hml_freq.reduce (a,b)->a+b


  class Packet
    constructor: (@smac, @dmac, @ip, @port, @tower, @time)->

    @towers:[
      {
        cell_id:3211,
        mcc:345,
        mnc:32,
        lac:16,
        service:'Vodafone'
      },
      {
        cell_id:9271,
        mcc:445,
        mnc:89,
        lac:12,
        service:'Airtel'
      },
      {
        cell_id:8889,
        mcc:675,
        mnc:23,
        lac:90,
        service:'Idea'
      },
      {
        cell_id:1234,
        mcc:908,
        mnc:70,
        lac:67,
        service:'Reliance'
      }
    ]

  class Person
    state:'absent'
    last:0
    interval:0
    ph_int:0
    ###
      mac= mac address of the phone of the user
      frequency= times per day the user visits
      freq_ph_usage= times per visit the user operates phone
      stay_time= time in minutes the user stays at the place
      pop_limit= If the count of people at the place is above this number, the user
                 will leave the place, or won't visit.
    ###
    constructor: (@mac, @frequency, @freq_ph_usage, @stay_time, @pop_limit)->
      t_int = (1440-@frequency*@stay_time)/@frequency
      @interval = Math.floor((Math.random() * t_int*0.9) + t_int*0.8)
      @ph_int = Math.floor((Math.random() * @stay_time/@freq_ph_usage*0.9)+@stay_time/@freq_ph_usage*0.8)
      @last=-1
      console.log @

    try_visit: (i,ulist)->
      if(i-@last >= @interval)
        @last=i
        present = (user for user in ulist when user.state is 'present').length
        if(present<@pop_limit)
          @state='present'
          for n in [1..@stay_time]
            if n%@ph_int is 0
              @use_phone(i,n,ulist)
          @state='absent'

    use_phone:(i,n,ulist)->
      list = (user for user in users when user.mac!=@mac)
      random_user = list[Math.floor((Math.random() * list.length))]
      tower = Packet.towers[ulist.indexOf(@)%4]
      packet = new Packet @mac, random_user.mac, @mac,9000,tower,i
      conn.sendText JSON.stringify packet
      gc()
      #console.log packet

  users=[]
  for num in [1..Number(population)]
    mac=require('crypto').createHash('md5').update("#{num}").digest("hex")
    frequency=0
    freq_ph_usage=0
    stay_time=0
    pop_limit=0

    if hml_freq[0]
      frequency=Math.floor((Math.random() * 5) + 4)
      hml_freq[0]--
    else if hml_freq[1]
      frequency=Math.floor((Math.random() * 3) + 2)
      hml_freq[1]--
    else if hml_freq[2]
      frequency=Math.floor((Math.random() * 2) + 1)
      hml_freq[2]--

    if hml_freq_ph_usage[0]
      freq_ph_usage=Math.floor((Math.random() * 10) + 8)
      hml_freq_ph_usage[0]--
    else if hml_freq_ph_usage[1]
      freq_ph_usage=Math.floor((Math.random() * 7) + 3)
      hml_freq_ph_usage[1]--
    else if hml_freq_ph_usage[2]
      freq_ph_usage=Math.floor((Math.random() * 2) + 1)
      hml_freq_ph_usage[2]--

    if hml_stay_time[0]
      stay_time=Math.floor((Math.random() * 60) + 45)
      hml_stay_time[0]--
    else if hml_stay_time[1]
      stay_time=Math.floor((Math.random() * 40) + 25)
      hml_stay_time[1]--
    else if hml_stay_time[2]
      stay_time=Math.floor((Math.random() * 20) + 5)
      hml_stay_time[2]--

    if hml_pop_limit[0]
      pop_limit=Math.floor((Math.random() * 20) + 15)
      hml_pop_limit[0]--
    else if hml_pop_limit[1]
      pop_limit=Math.floor((Math.random() * 14) + 7)
      hml_pop_limit[1]--
    else if hml_pop_limit[2]
      pop_limit=Math.floor((Math.random() * 6) + 2)
      hml_pop_limit[2]--

    users.push new Person(mac,frequency,freq_ph_usage,stay_time,pop_limit)

    setInterval ->
      for i in [1..24*60]
        for user in users
          user.try_visit(i,users)
        for user in users
          user.last=-1
          user.state='absent'
    ,100
).listen(6001)
