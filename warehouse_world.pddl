(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   (:action robotMove
        :parameters(?s - location ?d - location ?r - robot)
        :precondition (and (at ?r ?s) (connected ?s ?d)(not (no-robot ?s))(no-robot ?d))
        :effect (and (not (at ?r ?s)) (at ?r ?d)(not (no-robot ?d)) (no-robot ?s))
   )
   (:action robotMoveWithPallette
        :parameters (?s - location ?d - location ?r - robot ?p - pallette)
        :precondition (and (at ?p ?s) (at ?r ?s) (connected ?s ?d)(no-pallette ?d)(not (no-pallette ?s))(no-robot ?d)(not (no-robot ?s)))
        :effect (and (not (at ?p ?s)) (not (at ?r ?s)) (at ?r ?d) (at ?p ?d) (has ?r ?p) (not (no-pallette ?d)) (no-pallette ?s) (no-robot ?s)(not (no-robot ?d)))
   )
   (:action moveItemFromPalletteToShipment
        :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
        :precondition (and (contains ?p ?si) (at ?p ?l) (packing-at ?s ?l) (started ?s) (orders ?o ?si))
        :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )
   (:action completeShipment
        :parameters (?s - shipment ?o - order ?l - location)
        :precondition (and (ships ?s ?o) (packing-location ?l) (packing-at ?s ?l)(started ?s)(not (unstarted ?s)))
        :effect (and (complete ?s) (not (started ?s))(available ?l) (not (packing-at ?s ?l)))
   )
)
