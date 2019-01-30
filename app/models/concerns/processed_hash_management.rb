module ProcessedHashManagement
  extend ActiveSupport::Concern

  included do
    # Hash that needs to be merged with Ocr response if merging is enabled.
    REQUIRED_HASH = {
        ShipperName: nil,
        ShipperAddress: nil,
        ShipperCity: nil,
        ShipperState: nil,
        ShipperZip: nil,
        ShipperContactPhone: nil,
        ShipperContactFax: nil,
        ShipperContactEmail: nil,
        ShipperContactName: nil,
        ConsigneeName: nil,
        ConsigneeAddress: nil,
        ConsigneeAddress2: nil,
        ConsigneeCity: nil,
        ConsigneeState: nil,
        ConsigneeZip: nil,
        ConsigneeContactPhone: nil,
        ConsigneeContactFax: nil,
        ConsigneeContactEmail: nil,
        ConsigneeContactName: nil,
        ThirdPartyName: nil,
        ThirdPartyAddress: nil,
        ThirdPartyAddress2: nil,
        ThirdPartyCity: nil,
        ThirdPartyState: nil,
        ThirdPartyZip: nil,
        ThirdPartyContactPhone: nil,
        ThirdPartyContactFax: nil,
        ThirdPartyContactEmail: nil,
        ThirdPartyContactName: nil,
        SpecialInstructions: nil,
        BolNumber: nil,
        PoNumber: nil,
        EmergencyContactInfo: nil,
        PaymentTerms: nil,
        ShipmentDate: nil,
        PreAssignedPittPro: nil,
        Details: [
          {
            "Pieces": nil,
            "PackageType": nil,
            "Weight": nil,
            "Hazmat": nil,
            "Description": nil,
            "Class": nil
          }
        ]
    }.freeze

    # Defined Values of PaymentTerms
    PAYMENT_TERMS = {
      'PPD' => 'Prepaid',
      'COL' => 'Collect',
      '3RD' => 'Third Party'
    }.freeze
  end
end