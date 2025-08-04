;; Component Origin Verification Contract
;; Tracks the source and origin of electronic components

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-COMPONENT-EXISTS (err u101))
(define-constant ERR-COMPONENT-NOT-FOUND (err u102))
(define-constant ERR-INVALID-INPUT (err u103))
(define-constant ERR-SUPPLIER-NOT-FOUND (err u104))

;; Data Variables
(define-data-var next-component-id uint u1)

;; Data Maps
(define-map components
  { component-id: (string-ascii 50) }
  {
    supplier: (string-ascii 100),
    component-type: (string-ascii 50),
    origin-country: (string-ascii 50),
    manufacturing-date: uint,
    certification-level: uint,
    registered-by: principal,
    registration-block: uint
  }
)

(define-map suppliers
  { supplier-name: (string-ascii 100) }
  {
    country: (string-ascii 50),
    certification-status: bool,
    reputation-score: uint,
    registered-by: principal,
    registration-block: uint
  }
)

(define-map component-history
  { component-id: (string-ascii 50), event-id: uint }
  {
    event-type: (string-ascii 50),
    description: (string-ascii 200),
    timestamp: uint,
    recorded-by: principal
  }
)

;; Read-only functions
(define-read-only (get-component (component-id (string-ascii 50)))
  (map-get? components { component-id: component-id })
)

(define-read-only (get-supplier (supplier-name (string-ascii 100)))
  (map-get? suppliers { supplier-name: supplier-name })
)

(define-read-only (get-component-history (component-id (string-ascii 50)) (event-id uint))
  (map-get? component-history { component-id: component-id, event-id: event-id })
)

(define-read-only (is-component-registered (component-id (string-ascii 50)))
  (is-some (map-get? components { component-id: component-id }))
)

(define-read-only (is-supplier-certified (supplier-name (string-ascii 100)))
  (match (map-get? suppliers { supplier-name: supplier-name })
    supplier (get certification-status supplier)
    false
  )
)

;; Public functions
(define-public (register-supplier (supplier-name (string-ascii 100))
                                 (country (string-ascii 50))
                                 (certification-status bool))
  (begin
    (asserts! (> (len supplier-name) u0) ERR-INVALID-INPUT)
    (asserts! (> (len country) u0) ERR-INVALID-INPUT)
    (asserts! (is-none (map-get? suppliers { supplier-name: supplier-name })) ERR-COMPONENT-EXISTS)

    (map-set suppliers
      { supplier-name: supplier-name }
      {
        country: country,
        certification-status: certification-status,
        reputation-score: u50,
        registered-by: tx-sender,
        registration-block: block-height
      }
    )
    (ok true)
  )
)

(define-public (register-component (component-id (string-ascii 50))
                                  (supplier (string-ascii 100))
                                  (component-type (string-ascii 50))
                                  (origin-country (string-ascii 50)))
  (begin
    (asserts! (> (len component-id) u0) ERR-INVALID-INPUT)
    (asserts! (> (len supplier) u0) ERR-INVALID-INPUT)
    (asserts! (> (len component-type) u0) ERR-INVALID-INPUT)
    (asserts! (> (len origin-country) u0) ERR-INVALID-INPUT)
    (asserts! (is-none (map-get? components { component-id: component-id })) ERR-COMPONENT-EXISTS)
    (asserts! (is-some (map-get? suppliers { supplier-name: supplier })) ERR-SUPPLIER-NOT-FOUND)

    (map-set components
      { component-id: component-id }
      {
        supplier: supplier,
        component-type: component-type,
        origin-country: origin-country,
        manufacturing-date: block-height,
        certification-level: u1,
        registered-by: tx-sender,
        registration-block: block-height
      }
    )

    (map-set component-history
      { component-id: component-id, event-id: u1 }
      {
        event-type: "REGISTRATION",
        description: "Component registered in origin verification system",
        timestamp: block-height,
        recorded-by: tx-sender
      }
    )
    (ok true)
  )
)

(define-public (update-certification-level (component-id (string-ascii 50)) (new-level uint))
  (let ((component (unwrap! (map-get? components { component-id: component-id }) ERR-COMPONENT-NOT-FOUND)))
    (asserts! (< new-level u6) ERR-INVALID-INPUT)
    (asserts! (or (is-eq tx-sender CONTRACT-OWNER)
                  (is-eq tx-sender (get registered-by component))) ERR-NOT-AUTHORIZED)

    (map-set components
      { component-id: component-id }
      (merge component { certification-level: new-level })
    )
    (ok true)
  )
)

(define-public (update-supplier-reputation (supplier-name (string-ascii 100)) (new-score uint))
  (let ((supplier (unwrap! (map-get? suppliers { supplier-name: supplier-name }) ERR-SUPPLIER-NOT-FOUND)))
    (asserts! (<= new-score u100) ERR-INVALID-INPUT)
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)

    (map-set suppliers
      { supplier-name: supplier-name }
      (merge supplier { reputation-score: new-score })
    )
    (ok true)
  )
)

(define-public (add-component-event (component-id (string-ascii 50))
                                   (event-id uint)
                                   (event-type (string-ascii 50))
                                   (description (string-ascii 200)))
  (begin
    (asserts! (is-some (map-get? components { component-id: component-id })) ERR-COMPONENT-NOT-FOUND)
    (asserts! (> (len event-type) u0) ERR-INVALID-INPUT)
    (asserts! (> event-id u0) ERR-INVALID-INPUT)

    (map-set component-history
      { component-id: component-id, event-id: event-id }
      {
        event-type: event-type,
        description: description,
        timestamp: block-height,
        recorded-by: tx-sender
      }
    )
    (ok true)
  )
)
