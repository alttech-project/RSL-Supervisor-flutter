




import 'dart:convert';

class MyTripsRequestData {
  String? locationId;
  String? supervisorId;
  int? start;
  int? limit;
  String? driverName;
  String? from;
  String? to;
  String? tripId;

  MyTripsRequestData(
      {this.locationId,
        this.supervisorId,
        this.start,
        this.limit,
        this.driverName,
        this.from,
        this.to,
        this.tripId});

  MyTripsRequestData.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    supervisorId = json['supervisor_id'];
    start = json['start'];
    limit = json['limit'];
    driverName = json['driver_name'];
    from = json['from'];
    to = json['to'];
    tripId = json['trip_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_id'] = locationId;
    data['supervisor_id'] = supervisorId;
    data['start'] = start;
    data['limit'] = limit;
    data['driver_name'] = driverName;
    data['from'] = from;
    data['to'] = to;
    data['trip_id'] = tripId;
    return data;
  }
}


class MyTripsResponseData {
  String? message;
  Details? details;
  int? status;
  String? authKey;

  MyTripsResponseData({this.message, this.details, this.status, this.authKey});

  MyTripsResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    details =
    json['details'] != null ? Details.fromJson(json['details']) : null;
    status = json['status'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['status'] = status;
    data['auth_key'] = authKey;
    return data;
  }
}

class Details {
  List<ListTripDetails>? tripDetails;
  int? totalCount;

  Details({this.tripDetails, this.totalCount});

  Details.fromJson(Map<String, dynamic> json) {
    if (json['trip_details'] != null) {
      tripDetails = <ListTripDetails>[];
      json['trip_details'].forEach((v) {
        tripDetails!.add(ListTripDetails.fromJson(v));
      });
    }
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tripDetails != null) {
      data['trip_details'] = tripDetails!.map((v) => v.toJson()).toList();
    }
    data['total_count'] = totalCount;
    return data;
  }
}

class ListTripDetails {
  int? iId;
  int? tripId;
  int? driverId;
  String? waitingtime;
  String? driverName;
  String? driverRslNo;
  int? taxiId;
  String? taxiNo;
  int? taxiModelid;
  String? distance;
  String? distanceUnit;
  String? tripMinutes;
  String? modelName;
  String? pickupLocation;
  String? dropLocation;
  String? pickupTime;
  String? createdate;
  String? dropTime;
  int? tripFare;
  int? waitingCost;
  int? tollAmount;
  String? kioskAddress;
  String? kioskName;
  int? paymentType;
  String? quickOffline;
  int? kioskFareType;
  int? zoneFareApplied;
  String? roomNo;
  String? hourlyFareDuration;
  int? travelStatus;
  String? paymentId;
  String? flightNumber;
  String? referenceNumber;
  String? passengerName;
  String? noShow;
  String? paymentText;
  String? completeTripMap;
  String? tripType;
  int? actingSupervisorId;
  String? actingSupervisorName;
  String? supervisorTripMessage;
  String? supervisorCancelMessage;
  String? supervisorUniqueId;
  String? supervisorDisplayName;
  String? trackUrl;
  int? cancelledTrips;
  int? dispatchedTrips;
  String? driverReply;
  String? travelStatusMessage;

  ListTripDetails(
      {this.iId,
        this.tripId,
        this.driverId,
        this.waitingtime,
        this.driverName,
        this.driverRslNo,
        this.taxiId,
        this.taxiNo,
        this.taxiModelid,
        this.distance,
        this.distanceUnit,
        this.tripMinutes,
        this.modelName,
        this.pickupLocation,
        this.dropLocation,
        this.pickupTime,
        this.createdate,
        this.dropTime,
        this.tripFare,
        this.waitingCost,
        this.tollAmount,
        this.kioskAddress,
        this.kioskName,
        this.paymentType,
        this.quickOffline,
        this.kioskFareType,
        this.zoneFareApplied,
        this.roomNo,
        this.hourlyFareDuration,
        this.travelStatus,
        this.paymentId,
        this.flightNumber,
        this.referenceNumber,
        this.passengerName,
        this.noShow,
        this.paymentText,
        this.completeTripMap,
        this.tripType,
        this.actingSupervisorId,
        this.actingSupervisorName,
        this.supervisorTripMessage,
        this.supervisorCancelMessage,
        this.supervisorUniqueId,
        this.supervisorDisplayName,
        this.trackUrl,
        this.cancelledTrips,
        this.dispatchedTrips,
        this.driverReply,
        this.travelStatusMessage});

  ListTripDetails.fromJson(Map<String, dynamic> json) {
    try {
      iId = int.parse(json['_id'].toString());
    } catch (error){

    }
    try {
      tripId = int.parse(json['trip_id'].toString());
    } catch (error){

    }
    try {
      driverId = int.parse(json['driver_id'].toString());
    } catch (error){

    }

    waitingtime = json['waitingtime'].toString();
    driverName = json['driver_name'].toString();
    driverRslNo = json['driver_rsl_no'].toString();
    try {
      taxiId = int.parse(json['taxi_id'].toString());
    } catch (error){

    }
    taxiNo = json['taxi_no'].toString();
    try {
      taxiModelid = int.parse(json['taxi_modelid'].toString());
    } catch (error){

    }
    distance = json['distance'].toString();
    distanceUnit = json['distance_unit'].toString();
    tripMinutes = json['trip_minutes'].toString();
    modelName = json['model_name'].toString();
    pickupLocation = json['pickup_location'].toString();
    dropLocation = json['drop_location'].toString();
    pickupTime = json['pickup_time'].toString();
    createdate = json['createdate'].toString();
    dropTime = json['drop_time'].toString();
    try {
      tripFare = int.parse(json['trip_fare'].toString());
    } catch (error){

    }
    try {
      waitingCost = int.parse(json['waiting_cost'].toString());
    } catch (error){

    }
    try {
      tollAmount = int.parse(json['toll_amount'].toString());
    } catch (error){

    }
    kioskAddress = json['kiosk_address'].toString();
    kioskName = json['kiosk_name'].toString();
    try {
      paymentType = int.parse(json['payment_type'].toString());
    } catch (error){

    }
    quickOffline = json['quick_offline'].toString();
    try {
      kioskFareType = int.parse(json['kiosk_fare_type'].toString());
    } catch (error){

    }
    try {
      zoneFareApplied = int.parse(json['zone_fare_applied'].toString());
    } catch (error){

    }
    roomNo = json['room_no'].toString();
    hourlyFareDuration = json['hourly_fare_duration'].toString();
    try {
      travelStatus = int.parse(json['travel_status'].toString());
    } catch (error){

    }
    paymentId = json['payment_id'].toString();
    flightNumber = json['flight_number'].toString();
    referenceNumber = json['reference_number'].toString();
    passengerName = json['passenger_name'].toString();
    noShow = json['no_show'].toString();
    paymentText = json['payment_text'].toString();
    completeTripMap = json['complete_trip_map'].toString();
    tripType = json['trip_type'].toString();
    try {
      actingSupervisorId = int.parse(json['acting_supervisor_id'].toString());
    } catch (error){

    }
    actingSupervisorName = json['acting_supervisor_name'].toString();
    supervisorTripMessage = json['supervisor_trip_message'].toString();
    supervisorCancelMessage = json['supervisor_cancel_message'].toString();
    supervisorUniqueId = json['supervisor_unique_id'].toString();
    supervisorDisplayName = json['supervisor_display_name'].toString();
    trackUrl = json['track_url'].toString();
    try {
      cancelledTrips = int.parse(json['cancelled_trips'].toString());
    } catch (error){

    }
    try {
      dispatchedTrips = int.parse(json['dispatched_trips'].toString());
    } catch (error){

    }
    driverReply = json['driver_reply'].toString();
    travelStatusMessage = json['travel_status_message'].toString();
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = iId;
    data['trip_id'] = tripId;
    data['driver_id'] = driverId;
    data['waitingtime'] = waitingtime;
    data['driver_name'] = driverName;
    data['driver_rsl_no'] = driverRslNo;
    data['taxi_id'] = taxiId;
    data['taxi_no'] = taxiNo;
    data['taxi_modelid'] = taxiModelid;
    data['distance'] = distance;
    data['distance_unit'] = distanceUnit;
    data['trip_minutes'] = tripMinutes;
    data['model_name'] = modelName;
    data['pickup_location'] = pickupLocation;
    data['drop_location'] = dropLocation;
    data['pickup_time'] = pickupTime;
    data['createdate'] = createdate;
    data['drop_time'] = dropTime;
    data['trip_fare'] = tripFare;
    data['waiting_cost'] = waitingCost;
    data['toll_amount'] = tollAmount;
    data['kiosk_address'] = kioskAddress;
    data['kiosk_name'] = kioskName;
    data['payment_type'] = paymentType;
    data['quick_offline'] = quickOffline;
    data['kiosk_fare_type'] = kioskFareType;
    data['zone_fare_applied'] = zoneFareApplied;
    data['room_no'] = roomNo;
    data['hourly_fare_duration'] = hourlyFareDuration;
    data['travel_status'] = travelStatus;
    data['payment_id'] = paymentId;
    data['flight_number'] = flightNumber;
    data['reference_number'] = referenceNumber;
    data['passenger_name'] = passengerName;
    data['no_show'] = noShow;
    data['payment_text'] = paymentText;
    data['complete_trip_map'] = completeTripMap;
    data['trip_type'] = tripType;
    data['acting_supervisor_id'] = actingSupervisorId;
    data['acting_supervisor_name'] = actingSupervisorName;
    data['supervisor_trip_message'] = supervisorTripMessage;
    data['supervisor_cancel_message'] = supervisorCancelMessage;
    data['supervisor_unique_id'] = supervisorUniqueId;
    data['supervisor_display_name'] = supervisorDisplayName;
    data['track_url'] = trackUrl;
    data['cancelled_trips'] = cancelledTrips;
    data['dispatched_trips'] = dispatchedTrips;
    data['driver_reply'] = driverReply;
    data['travel_status_message'] = travelStatusMessage;
    return data;
  }
}



String tripListRequestToJson(MyTripsRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

MyTripsResponseData tripListResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return MyTripsResponseData.fromJson(jsonData);
}