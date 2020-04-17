(define (domain cooperation)
	(:requirements :strips :typing :equality :negative-preconditions :fluents 
		:durative-actions :preferences :constraints)
	(:types
		dock - object
		coordX coordY - object 
		unmanned-vehicle - object
        uav ugv - unmanned-vehicle
        navmode - object
        pan - object
        tilt - object
	)
	(:predicates 
		(at-position ?elem - (either dock unmanned-vehicle) ?x - coordX ?y - coordY)
		(at-dock ?uv - unmanned-vehicle ?d - dock)
		(has-nav-mode ?uv - unmanned-vehicle ?m - navmode)
		(is-taken-picture ?uv - unmanned-vehicle ?x - coordX ?y - coordY ?p - pan ?t - tilt)
		(is-picture-sent ?uv - unmanned-vehicle ?x - coordX ?y - coordY ?p - pan ?t - tilt)
		(is-horizontal-pan ?uv - unmanned-vehicle ?p - pan)
		(is-horizontal-tilt ?uv - unmanned-vehicle ?t - tilt)
	)
	(:functions 
		(speed ?m - navmode)
		(distance ?x1 - coordX ?y1 - coordY ?x2 - coordX ?y2 - coordY)
		(total-time-use)
		
	)
	
	(:durative-action dock
	   :parameters(?d - dock ?uv -unmanned-vehicle ?x - coordX ?y - coordY)
	   :duration(= ?duration 1)
       :condition(and
					(at start (at-position ?d ?x ?y))
					(at start (at-position ?uv ?x ?y))
				)
	   :effect(and
					(at start (not(at-position ?uv ?x ?y)))
					(at end (at-dock ?uv ?d))
					(at end (increase (total-time-use) 1))
				)
	)
	(:durative-action undock
	   :parameters(?d - dock ?uv -unmanned-vehicle ?x - coordX ?y - coordY)
	   :duration(= ?duration 1)
       :condition(and 
					(at start (at-position ?d ?x ?y))
				)
	   :effect(and 
					(at start (not(at-dock ?uv ?d)))
					(at end (at-position ?uv ?x ?y))
					(at end (increase (total-time-use) 1))
				)
	)
	(:durative-action move
		:parameters(?uv - unmanned-vehicle ?fromX - coordX  ?fromY - coordY ?toX - coordX ?toY - coordY ?mode - navmode)
		:duration(= ?duration (/(speed ?mode)(distance ?fromX ?fromY ?toX ?toY)))
        :condition(and
					(at start (has-nav-mode ?uv ?mode))
					(at start (at-position ?uv ?fromX ?fromY))
				)
        :effect (and
					(at start (not(at-position ?uv ?fromX ?fromY)))
					(at end (at-position ?uv ?toX ?toY))
					(at end (increase (total-time-use) (/(speed ?mode)(distance ?fromX ?fromY ?toX ?toY))))
				)
    )
	(:durative-action take_picture
        :parameters(?uv - unmanned-vehicle ?x - coordX ?y - coordY ?p - pan ?t - tilt)
		:duration(= ?duration 1)
        :condition(and
					(at start (at-position ?uv ?x ?y))
        )
		:effect (and 
					(at end (is-taken-picture ?uv ?x ?y ?p ?t))
					(at end (increase (total-time-use) 1))
				)
    )
	
	(:durative-action rotation-pan
		:parameters(?uv - unmanned-vehicle ?pan1 ?pan2 - pan)
		:duration(= ?duration 1)
 		:condition(at start (is-horizontal-pan ?uv ?pan1))
		:effect(and
					(at end (is-horizontal-pan ?uv ?pan2))
					(at end (increase (total-time-use) 1))
				)
	)
	
	(:durative-action rotation-tilt
		:parameters(?uv - unmanned-vehicle ?tilt1 ?tilt2 - tilt)
		:duration(= ?duration 1)
		:condition(at start (is-horizontal-tilt ?uv ?tilt1))
		:effect(and
					(at end (is-horizontal-tilt ?uv ?tilt2))
					(at end (increase (total-time-use) 1))
				)
	)
	
	(:durative-action change-nav-mode
		:parameters(?uv - unmanned-vehicle ?mode1 ?mode2 - navmode)
		:duration(= ?duration 1)
		:condition(at start (has-nav-mode ?uv ?mode1))
		:effect(and
					(at end (has-nav-mode ?uv ?mode2))
					(at end (increase (total-time-use) 1))
				)
	)
	
	(:durative-action transmit-image
		:parameters(?uv - unmanned-vehicle ?x - coordX ?y - coordY ?p - pan ?t - tilt)
		:duration(= ?duration 1)
		:condition(and 
						(at start (is-taken-picture ?uv ?x ?y ?p ?t))
					)
		:effect(and
					(at end(is-picture-sent ?uv ?x ?y ?p ?t))
					(at end (increase (total-time-use) 1))
				)
	)
	
	
)