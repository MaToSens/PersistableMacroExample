//
//  DatabaseManager.swift
//  PersistableMacroExample
//
//  Created by MaTooSens on 23/03/2025.
//

import Foundation
import Persistable

fileprivate struct DAOFactory {
    static func initializeObject<DAO: LocalDAO, Object: Persistable>(from dao: DAO) -> Object {
        guard let dao = dao as? Object.DAO else { fatalError() }
        return Object(from: dao)
    }
    
    static func initializeDAO<Object: Persistable, DAO: LocalDAO>(from object: Object) -> DAO {
        guard let object = object as? DAO.Model else { fatalError() }
        return DAO(from: object)
    }
}

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let realm: Realm
    private init() { self.realm = try! Realm() }
    
    func create<Object: Persistable>(object: Object) throws {
        let objectDAO: Object.DAO = DAOFactory.initializeDAO(from: object)
        
        do {
            try realm.write { realm.add(objectDAO) }
        } catch {
            throw DatabaseError.unableToCreate
        }
    }
    
    func update<Object: Persistable>(object: Object) throws {
        let objectDAO: Object.DAO = DAOFactory.initializeDAO(from: object)
        
        do {
            try realm.write { realm.add(objectDAO, update: .modified) }
        } catch {
            throw DatabaseError.unableToUpdate
        }
    }
    
    func readAll<Object: Persistable>() throws -> [Object] {
        let objects: [Object] = realm
            .objects(Object.DAO.self)
            .compactMap { DAOFactory.initializeObject(from: $0) }
        
        guard !objects.isEmpty
        else { throw DatabaseError.unableToRead }
        
        return objects
    }
    
    func delete<Object: Persistable>(object: Object) throws {
        guard let objectDAO = realm.object(
            ofType: Object.DAO.self,
            forPrimaryKey: String(describing: object.id)
        ) else {
            throw DatabaseError.unableToRead
        }
        
        do {
            try realm.write { realm.delete(objectDAO) }
        } catch {
            throw DatabaseError.unableToDelete
        }
    }
}

public enum DatabaseError: LocalizedError {
    case unableToOpenRealm
    case unableToCreate
    case unableToRead
    case unableToUpdate
    case unableToDelete

    public var errorDescription: String? {
        switch self {
        case .unableToOpenRealm: return "📂 Ups! Wystąpił problem z otwarciem bazy danych."
        case .unableToCreate: return "➕ Nie udało się zapisać danych."
        case .unableToRead: return "📖 Nie udało się odczytać danych."
        case .unableToUpdate: return "♻️ Nie udało się zaktualizować danych."
        case .unableToDelete: return "🗑️ Nie udało się usunąć danych."
        }
    }
}
