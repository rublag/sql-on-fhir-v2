Instance:   PatientDemographics
InstanceOf: ViewDefinition
Description: """A minimal example of a patient demographics view.
This view uses the first 'official' patient name for our demographics table."""
Usage:  #example
* name = "patient_demographics"
* status = #draft
* resource = #Patient
* select[+]
  * column[+]
    * path = "getResourceKey()"
    * alias = "id"
  * column[+]
    * path = "gender"
* select[+]
  * forEach = "name.where(use = 'official').first()"
  * column[+]
    * path = "given.join(' ')"
    * alias = "given_name"
    * description = "A single given name field with all names joined together."
  * column[+]
    * path = "family"
    * alias = "family_name"

Instance:   PatientAddresses
InstanceOf: ViewDefinition
Description: """An example of unnesting patient addresses into multiple
rows.

This view uses `forEach` to indicate we are unrolling these into separate rows. 
The `join` function is used to create a single address line.
"""
Usage:  #example
* name = "patient_addresses"
* status = #draft
* resource = #Patient
* select[+]
  * column[+]
    * path = "getResourceKey()"
    * alias = "patient_id"
* select[+]
  * forEach = "address"
  * column[+]
    * path = "line.join('\n')"
    * alias = "street"
    * description = "The full street address, including newlines if present."
  * column[+]
    * path = "use"
  * column[+]
    * path = "city"
  * column[+]
    * path = "postalCode"
    * alias = "zip"

Instance: UsCoreBloodPressures
InstanceOf: ViewDefinition
Description: """A simple view of blood pressure observations, with separate columns for 
systolic and diastolic values."""
Usage: #example
* name =  "us_core_blood_pressures"
* status = #draft
* resource =  #Observation
* constant[+]
  * name = "systolic_bp"
  * valueCode = #8480-6
* constant[+]
  * name = "diastolic_bp"
  * valueCode = #8462-4
* constant[+]
  * name = "bp_code"
  * valueCode = #85354-9
* select[+]
  * column[+]
    * path = "getResourceKey()"
    * alias = "id"
  * column[+]
    * path = "subject.getReferenceKey('Patient')"
    * alias = "patient_id"
    * description = "Can be used to join to patient tables created by other views."
  * column[+]
    * path =  "effective.ofType(dateTime)"
    * alias = "effective_date_time"
* select[+]
  * forEach = "component.where(code.coding.exists(system='http://loinc.org' and code=%systolic_bp)).first()"
  * column[+]
    * alias = "sbp_quantity_system"
    * path = "value.ofType(Quantity).system"
  * column[+]
    * alias = "sbp_quantity_code"
    * path = "value.ofType(Quantity).code"
  * column[+]
    * alias = "sbp_quantity_display"
    * path = "value.ofType(Quantity).unit"
  * column[+]
    * alias = "sbp_quantity_value"
    * path = "value.ofType(Quantity).value"
* select[+]
  * forEach = "component.where(code.coding.exists(system='http://loinc.org' and code=%diastolic_bp)).first()"
  * column[+]
    * alias = "dbp_quantity_system"
    * path = "value.ofType(Quantity).system"
  * column[+]
    * alias = "dbp_quantity_code"
    * path = "value.ofType(Quantity).code"
  * column[+]
    * alias = "dbp_quantity_display"
    * path = "value.ofType(Quantity).unit"
  * column[+]
    * alias = "dbp_quantity_value"
    * path = "value.ofType(Quantity).value"
* where[+]
  * path = "code.coding.exists(system='http://loinc.org' and code=%bp_code)"