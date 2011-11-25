model = Sketchup.active_model
entities = model.entities
selection = model.selection
definitions=model.definitions
view=model.active_view
#The definitions store each group or component
#with the problem being that each times it loads
#it potentially reverses the order
#animation works best with the lowest order
#of animated objects being the grouping of a component
#and a singular axis object
definitions.each{|e|
puts(e.name)
}
ents_Wheel_Add=definitions[1].entities
puts ents_Wheel_Add.length
trans=Geom::Transformation.new([0,0,0],[0,0,1],0.2618)
transb=trans.inverse
transl=Geom::Transformation.new([-9.48,0,0])
translb=transl.inverse
for i in 1..24 do
ents_Wheel_Add.transform_entities(transb,ents_Wheel_Add[0])
entities.transform_entities(translb,entities[0])
newview=view.refresh
sleep 0.1
end