//
//  Address.swift
//  weply
//
//  Created by Den Jo on 12/12/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation
import Contacts
import MapKit

struct Address: Equatable, Autocomplete {
    /// Street address
    var thoroughfare: String?
    
    /// Street address 2
    var subThoroughfare: String?
    
    /// city
    var locality: String?
    var subLocality: String?
    
    /// State, Province
    var administrativeArea: String?
    
    /// Area
    var subAdministrativeArea: String?
    
    var country: String?
    var countryCode: String?
    var postalCode: String?
}

extension Address {
    
    init(data: MKPlacemark) {
        thoroughfare          = data.thoroughfare
        subThoroughfare       = data.subThoroughfare
        locality              = data.locality
        subLocality           = data.subLocality
        administrativeArea    = data.administrativeArea
        subAdministrativeArea = data.subAdministrativeArea
        country               = data.country
        countryCode           = data.countryCode
        postalCode            = data.postalCode
    }
}

extension Address {
    
    var postalAddress: String {
        var postalAddress = ""
        switch countryCode {
        case "KR":
            if let administrativeArea = administrativeArea, administrativeArea != "" {
                postalAddress = administrativeArea
                
                if let subAdministrativeArea = subAdministrativeArea, subAdministrativeArea != "" {
                    postalAddress = "\(postalAddress) \(subAdministrativeArea)"
                }
            }
            
            if let locality = locality, locality != ""  {
                postalAddress = "\(postalAddress) \(locality)"
                
                if let subLocality = subLocality, subLocality != "" {
                    postalAddress = "\(postalAddress) \(subLocality)"
                }
            }
            
            if let thoroughfare = thoroughfare, thoroughfare != "" {
                postalAddress = "\(postalAddress) \(thoroughfare)"
            }
            
            if let subThoroughfare = subThoroughfare, subThoroughfare != "" {
                postalAddress = "\(postalAddress)\n\(subThoroughfare)"
            }
            
            if let postalCode = postalCode, postalCode != "" {
                postalAddress = "\(postalAddress)\n\(postalCode)"
            }
            
            if let country = country, country != "" {
                postalAddress = "\(postalAddress)\n\(country)"
            }
            
            return postalAddress
            
        default:
            if let thoroughfare = thoroughfare, thoroughfare != "" {
                postalAddress = thoroughfare
            }
            
            if let subThoroughfare = subThoroughfare, subThoroughfare != "" {
                postalAddress = "\(postalAddress)\n\(subThoroughfare)"
            }
            
            var localityString = ""
            if var locality = locality, locality != ""  {
                if let subLocality = subLocality, subLocality != "" {
                    locality = "\(subLocality), \(locality)"
                }
                
                localityString = locality
            }
            
            if var administrativeArea = administrativeArea, administrativeArea != "" {
                if let subAdministrativeArea = subAdministrativeArea, subAdministrativeArea != "" {
                    administrativeArea = "\(subAdministrativeArea) \(administrativeArea)"
                }
                
                localityString = "\(localityString)\(localityString != "" ? ", " : "")\(administrativeArea)"
            }
            postalAddress = "\(postalAddress)\n\(localityString)"
            
            if let postalCode = postalCode, postalCode != "" {
                postalAddress = "\(postalAddress)\n\(postalCode)"
            }
            
            if let country = country, country != "" {
                postalAddress = "\(postalAddress)\n\(country)"
            }
            
            return postalAddress
        }
    }
}

extension Address: Codable {
    
    private enum Key: String, CodingKey {
        case thoroughfare
        case subThoroughfare
        case locality
        case subLocality
        case administrativeArea
        case subAdministrativeArea
        case country
        case countryCode
        case postalCode
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(thoroughfare,          forKey: .thoroughfare) }          catch {}
        do { try container.encode(subThoroughfare,       forKey: .subThoroughfare) }       catch {}
        do { try container.encode(locality,              forKey: .locality) }              catch {}
        do { try container.encode(subLocality,           forKey: .subLocality) }           catch {}
        do { try container.encode(administrativeArea,    forKey: .administrativeArea) }    catch {}
        do { try container.encode(subAdministrativeArea, forKey: .subAdministrativeArea) } catch {}
        do { try container.encode(country,               forKey: .country) }               catch { throw EncodingError.invalidValue(container, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Failed to get a country.")) }
        do { try container.encode(countryCode,           forKey: .countryCode) }           catch { throw EncodingError.invalidValue(container, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Failed to get a countryCode.")) }
        do { try container.encode(postalCode,            forKey: .postalCode) }            catch { throw EncodingError.invalidValue(container, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Failed to get a postalCode.")) }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { country     = try container.decode(String.self, forKey: .country) }     catch { throw DecodingError.keyNotFound(Key.country, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a country.")) }
        do { countryCode = try container.decode(String.self, forKey: .countryCode) } catch { throw DecodingError.keyNotFound(Key.countryCode, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a countryCode.")) }
        do { postalCode  = try container.decode(String.self, forKey: .postalCode) }  catch { throw DecodingError.keyNotFound(Key.postalCode, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a postalCode.")) }
        
        do {
            let thoroughfare = try container.decode(String.self, forKey: .thoroughfare)
            self.thoroughfare = thoroughfare != "" ? thoroughfare : nil
        } catch {}
        
        do {
            let subThoroughfare = try container.decode(String.self, forKey: .subThoroughfare)
            self.subThoroughfare = subThoroughfare != "" ? subThoroughfare : nil
        } catch {}
        
        do {
            let locality = try container.decode(String.self, forKey: .locality)
            self.locality = locality != "" ? locality : nil
        } catch {}
        
        do {
            let subLocality = try container.decode(String.self, forKey: .subLocality)
            self.subLocality = subLocality != "" ? subLocality : nil
        } catch {}
        
        do {
            let administrativeArea = try container.decode(String.self, forKey: .administrativeArea)
            self.administrativeArea = administrativeArea != "" ? administrativeArea : nil
        } catch {}
        
        do {
            let subAdministrativeArea = try container.decode(String.self, forKey: .subAdministrativeArea)
            self.subAdministrativeArea = subAdministrativeArea != "" ? subAdministrativeArea : nil
        } catch {}
    }
}
