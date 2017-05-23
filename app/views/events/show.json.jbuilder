json.array! @events do |event|
  json.title event.event_name
  json.allDay false
  json.start DateTime.parse(event.start_date.to_s + " " + event.start_time.to_s)
  json.end DateTime.parse(event.end_date.to_s + " " + event.end_time.to_s)
  json.address event.address
  json.phone event.phone
  json.images event.images
  json.rating event.rating
  json.reviews event.reviews
  json.price event.price
  json.hours event.hours
  json.categories event.categories
end
