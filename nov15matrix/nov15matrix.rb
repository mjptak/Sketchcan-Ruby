model = Sketchup.active_model
entities = model.entities
selection = model.selection
definitions = model.definitions
view = model.active_view
elist=[]
i=0
entities.each{|e|
temp=[]
temp.push(i)
temp.push(e.name)
elist.push(temp)
i=i+1
}
elist.each{|e|
e.reverse!
}
elist.sort!
elist.each{|e|
e.reverse!
}
#puts elist
hlist={}
for i in 0..elist.length-1 do
hlist[elist[i][1]]=elist[i][0]
end
puts hlist[0]
hlist.each_key{|key|
#if key == "T0" || key == "T4" || key == "T8" || key == "TC"
    tran=entities[hlist[key]].transformation
    trana=tran.to_a
    trana[-4]=trana[-4]+1
    tran=Geom::Transformation.new(trana)
    entities[hlist[key]].transformation=tran
    sleep 0.2
    newview=view.refresh
#end
}
