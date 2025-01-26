class_name GameSession
extends RefCounted


const DISTANCE_SCORE_RATIO := 0.125

var start_time: float
var end_time: float
var distance: float
var pickups: int
var obstacles_destroyed: int

var play_time: float:
    get:
        if start_time > 0:
            if end_time > 0:
                return end_time - start_time
            else:
                return S.time.get_play_time() - start_time
        else:
            return 0

var score: int:
    get:
        return distance * DISTANCE_SCORE_RATIO


func _init() -> void:
    reset()


func reset() -> void:
    randomize()
    start_time = 0.0
    end_time = 0.0
    distance = 0.0
    pickups = 0
    obstacles_destroyed = 0
