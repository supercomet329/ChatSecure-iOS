//
//  OTRXMPPRoomOccupant.swift
//  ChatSecure
//
//  Created by David Chiles on 10/19/15.
//  Copyright © 2015 Chris Ballinger. All rights reserved.
//

import Foundation
import YapDatabase

public class OTRXMPPRoomOccupant: OTRYapDatabaseObject, YapDatabaseRelationshipNode {
    
    public static let roomEdgeName = "OTRRoomOccupantEdgeName"
    
    public var available = false
    
    /** This is the JID of the participant as it's known in teh room  ie baseball_chat@conference.dukgo.com/user123 */
    public var jid:String?
    
    /** This is the name your known as in the room. Seems to be username without domain */
    public var roomName:String?
    
    /**When given by the server we get the room participants reall JID*/
    public var realJID:String?
    
    public var roomUniqueId:String?
    
    public func yapDatabaseRelationshipEdges() -> [AnyObject]! {
        if let roomID = self.roomUniqueId {
            let relationship = YapDatabaseRelationshipEdge(name: OTRXMPPRoomOccupant.roomEdgeName, sourceKey: self.uniqueId, collection: OTRXMPPRoomOccupant.collection(), destinationKey: roomID, collection: OTRXMPPRoom.collection(), nodeDeleteRules: YDB_NodeDeleteRules.DeleteSourceIfDestinationDeleted)
            return [relationship]
        } else {
            return []
        }
    }
}