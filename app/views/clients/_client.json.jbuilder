# frozen_string_literal: true

json.call(client, :id, :name, :address, :district, :phone)
json.referencePoint client.reference_point
json.gpsLink client.gps_link
