module ProcessedHashManagement
  extend ActiveSupport::Concern

  included do
    # Hash that needs to be merged with Ocr response if merging is enabled.
    MERGING_HASH = {
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
        'PPD' => { 'value' => 'Prepaid', 'options' => [%Q[Prepaid X], %Q[Prepaid \n], %Q[Prepaid :], %Q[PA: PPA], %Q[PPA ], %Q[Prepaid \n ring \n], %Q[Prepaid \n], %Q[Prepaid FOB SP], %Q[PREPAID FOB SP \n], %Q[Freight Charge Terms : Pre - Paid \n], %Q[Prepaid _ X _ _ \n], %Q[Prepaid _ x \n], %Q[Prepaid x \n], %Q[Prepaid X \n], %Q[ _ X _ Prepaid \n], %Q[\u00der charges are to be prepald , write or stamp here , To \n be Prepald \" \n PREPAID \n], %Q[Pre - Paid \n], %Q[]]},
        'COL' => { 'value' => 'Collect', 'options' => [%Q[COD Amt : $ 0 . 00 \n], %Q[Collect \n]] },
        '3RD' => { 'value' => 'Third Party', 'options' => [%Q[Freight Charge Terms : Collect - Third Party \n Rilling \n]] }
    }.freeze
  end
end
