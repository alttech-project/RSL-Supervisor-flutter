import 'dart:convert';

class TripHistoryRequest {
  String? kioskId;
  String? driverName;
  String? from;
  String? to;
  String? tripId;

  TripHistoryRequest({
    this.kioskId,
    this.driverName,
    this.from,
    this.to,
    this.tripId,
  });

  TripHistoryRequest.fromJson(Map<String, dynamic> json) {
    kioskId = json['kiosk_id'];
    driverName = json['driver_name'];
    from = json['from'];
    to = json['to'];
    tripId = json['trip_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kiosk_id'] = kioskId;
    data['driver_name'] = driverName;
    data['from'] = from;
    data['to'] = to;
    data['trip_id'] = tripId;
    return data;
  }
}

class TripHistoryResponse {
  String? message;
  List<TripDetails>? details;
  int? cancelledTripCount;
  int? dispatchedTripCount;
  int? status;
  String? authKey;

  TripHistoryResponse({
    this.message,
    this.details,
    this.cancelledTripCount,
    this.dispatchedTripCount,
    this.status,
    this.authKey,
  });

  TripHistoryResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['details'] != null) {
      details = <TripDetails>[];
      json['details'].forEach((v) {
        details!.add(TripDetails.fromJson(v));
      });
    }
    cancelledTripCount = json['cancelled_trip_count'];
    dispatchedTripCount = json['dispatched_trip_count'];
    status = json['status'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    data['cancelled_trip_count'] = cancelledTripCount;
    data['dispatched_trip_count'] = dispatchedTripCount;
    data['status'] = status;
    data['auth_key'] = authKey;
    return data;
  }
}

class TripDetails {
  String? iId;
  String? tripId;
  String? driverId;
  String? waitingtime;
  String? driverName;
  String? driverRslNo;
  String? taxiId;
  String? taxiNo;
  String? taxiModelid;
  String? distance;
  String? distanceUnit;
  String? tripMinutes;
  String? modelName;
  String? pickupLocation;
  String? dropLocation;
  String? pickupTime;
  String? createdate;
  String? dropTime;
  String? tripFare;
  String? waitingCost;
  String? tollAmount;
  String? kioskAddress;
  String? kioskName;
  String? paymentType;
  String? quickOffline;
  String? kioskFareType;
  String? zoneFareApplied;
  String? roomNo;
  String? hourlyFareDuration;
  String? travelStatus;
  String? paymentId;
  String? flightNumber;
  String? referenceNumber;
  String? passengerName;
  String? noShow;
  String? supervisorNotes;
  String? passengerNotes;
  String? paymentText;
  String? completeTripMap;
  String? tripType;
  String? actingSupervisorId;
  String? actingSupervisorName;
  String? supervisorTripMessage;
  String? supervisorCancelMessage;
  String? supervisorUniqueId;
  String? remarks;
  String? comments;
  String? supervisorDisplayName;
  String? trackUrl;
  String? cancelledTrips;
  String? dispatchedTrips;
  String? driverReply;
  String? travelStatusMessage;
  num? discountFare;


  TripDetails({
    this.iId,
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
    this.supervisorNotes,
    this.passengerNotes,
    this.paymentText,
    this.completeTripMap,
    this.tripType,
    this.actingSupervisorId,
    this.actingSupervisorName,
    this.supervisorTripMessage,
    this.supervisorCancelMessage,
    this.supervisorUniqueId,
    this.remarks,
    this.comments,
    this.supervisorDisplayName,
    this.trackUrl,
    this.cancelledTrips,
    this.dispatchedTrips,
    this.driverReply,
    this.travelStatusMessage,
    this.discountFare,


  });

  TripDetails.fromJson(Map<String, dynamic> json) {
    iId = json['_id'].toString();
    tripId = json['trip_id'].toString();
    driverId = json['driver_id'].toString();
    waitingtime = json['waitingtime'].toString();
    driverName = json['driver_name'].toString();
    driverRslNo = json['driver_rsl_no'].toString();
    taxiId = json['taxi_id'].toString();
    taxiNo = json['taxi_no'].toString();
    taxiModelid = json['taxi_modelid'].toString();
    distance = json['distance'].toString();
    distanceUnit = json['distance_unit'].toString();
    tripMinutes = json['trip_minutes'].toString();
    modelName = json['model_name'].toString();
    pickupLocation = json['pickup_location'].toString();
    dropLocation = json['drop_location'].toString();
    pickupTime = json['pickup_time'].toString();
    createdate = json['createdate'].toString();
    dropTime = json['drop_time'].toString();
    tripFare = json['trip_fare'].toString();
    waitingCost = json['waiting_cost'].toString();
    tollAmount = json['toll_amount'].toString();
    kioskAddress = json['kiosk_address'].toString();
    kioskName = json['kiosk_name'].toString();
    paymentType = json['payment_type'].toString();
    quickOffline = json['quick_offline'].toString();
    kioskFareType = json['kiosk_fare_type'].toString();
    zoneFareApplied = json['zone_fare_applied'].toString();
    roomNo = json['room_no'].toString();
    hourlyFareDuration = json['hourly_fare_duration'].toString();
    travelStatus = json['travel_status'].toString();
    paymentId = json['payment_id'].toString();
    flightNumber = json['flight_number'].toString();
    referenceNumber = json['reference_number'].toString();
    passengerName = json['passenger_name'].toString();
    noShow = json['no_show'].toString();
    supervisorNotes = json['supervisor_notes'].toString();
    passengerNotes = json['passenger_notes'].toString();
    paymentText = json['payment_text'].toString();
    completeTripMap = json['complete_trip_map'].toString();
    tripType = json['trip_type'].toString();
    actingSupervisorId = json['acting_supervisor_id'].toString();
    actingSupervisorName = json['acting_supervisor_name'].toString();
    supervisorTripMessage = json['supervisor_trip_message'].toString();
    supervisorCancelMessage = json['supervisor_cancel_message'].toString();
    supervisorUniqueId = json['supervisor_unique_id'].toString();
    remarks = json['remarks'].toString();
    comments = json['comments'].toString();
    supervisorDisplayName = json['supervisor_display_name'].toString();
    trackUrl = json['track_url'].toString();
    cancelledTrips = json['cancelled_trips'].toString();
    dispatchedTrips = json['dispatched_trips'].toString();
    driverReply = json['driver_reply'].toString();
    travelStatusMessage = json['travel_status_message'].toString();
    discountFare = json['discount_fare'];

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
    data['supervisor_notes'] = supervisorNotes;
    data['passenger_notes'] = passengerNotes;
    data['payment_text'] = paymentText;
    data['complete_trip_map'] = completeTripMap;
    data['trip_type'] = tripType;
    data['acting_supervisor_id'] = actingSupervisorId;
    data['acting_supervisor_name'] = actingSupervisorName;
    data['supervisor_trip_message'] = supervisorTripMessage;
    data['supervisor_cancel_message'] = supervisorCancelMessage;
    data['supervisor_unique_id'] = supervisorUniqueId;
    data['remarks'] = remarks;
    data['comments'] = comments;
    data['supervisor_display_name'] = supervisorDisplayName;
    data['track_url'] = trackUrl;
    data['cancelled_trips'] = cancelledTrips;
    data['dispatched_trips'] = dispatchedTrips;
    data['driver_reply'] = driverReply;
    data['travel_status_message'] = travelStatusMessage;
    return data;
  }
}

String tripHistoryRequestToJson(TripHistoryRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

TripHistoryResponse tripHistoryResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return TripHistoryResponse.fromJson(jsonData);
}
