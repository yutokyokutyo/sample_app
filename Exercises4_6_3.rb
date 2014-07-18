person1 = {}
person2 = {}
person3 = {}

person1[:aaa] = { first: "Yuto" , last: "Kondo" }
person2[:bbb] = { first: "Kentaro" , last: "Satou" }
person3[:ccc] = { first: "Yuka" , last: "Uchida" }

params = {}

params[:father] = person1[:aaa]
params[:mother] = person2[:bbb]
params[:child] = person3[:ccc]

puts params[:father][:first]    # Verify