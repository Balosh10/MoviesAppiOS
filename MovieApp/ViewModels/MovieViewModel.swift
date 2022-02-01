//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 29/01/22.
//

import Foundation
import UIKit
import CoreData

class MovieViewModel : NSObject {
        
    private(set) var movieData:CategoryModel! {
        didSet {
            self.bindMovieViewModelToController()
        }
    }
    
    private(set) var messageError:String! {
        didSet {
            self.bindMovieViewModelToController()
        }
    }
    
    var bindMovieViewModelToController : (() -> ()) = {}
    private var allMoviesTV: [SubCategoryModel] = [SubCategoryModel]()
    private var tvShows:[MoviesModel] = [MoviesModel]()
    private var movies: [MoviesModel] = [MoviesModel]()
    typealias updateItem = (_ moviesOrTvShow : MoviesModel?, _ index:Int?)  -> Void
    
    override init() {
        super.init()
        self.getMovieData()
    }
    
    struct TypeMovieData {
        let result:Result
        let type:List
    }
    
    func getMovieData() {
        
        guard InternetConnectionManager.isConnectedToNetwork() else {
            // Load list offline
            self.loadData()
            return
        }
        
        self.removeAllList()
        //
        // No se realiza la consulta de recomendaciones.
        // Se necesita el id para realizar la consulta de recomendaciones ¿?
        let endpoints:[TypeMovieData] = [TypeMovieData(result: .popular, type: .movie),
                                         /*TypeMovieData(result: .recommendations, type: .movie),*/
                                         TypeMovieData(result: .top_rated, type: .movie),
                                         TypeMovieData(result: .popular, type: .tv),
                                         /*TypeMovieData(result: .recommendations, type: .tv),*/
                                         TypeMovieData(result: .top_rated, type: .tv)]
        
        //
        // asynchronous call
        // the list is loaded at the end of the call
    
        let group = DispatchGroup()
        endpoints.forEach { i in
            
            group.enter()
                APIService.shared.fetchMovie(list: i.type, result: i.result, onSuccess: { response in
                    switch i.type {
                    case .movie:
                        self.movies.append(self.getTitle(movies:response, result: i.result, list:i.type))

                    case .tv:
                        self.tvShows.append(self.getTitle(movies:response, result: i.result, list: i.type))
                        
                    }
                    group.leave()
               }, onFailure: { error in
                   group.leave()
               })
        }

        // notify the main thread when all task are completed
        group.notify(queue: .main) {
            //Remove list data and create new list
            self.deleteData(model: .MoviesData)
            self.deleteData(model: .MovieResultData)
            self.createData(from: self.movies)
            self.createData(from: self.tvShows)
            self.loadData()
        }
        
    }
    //
    // get sub category
    func getTitle(movies:MoviesModel, result: Result, list:List) -> MoviesModel {
        var newResponse = movies
        newResponse.type = list.rawValue
        switch result {
        case .popular:
            newResponse.title = Localizable.text(.favorites)
        case .recommendations:
            newResponse.title = Localizable.text(.recommended)
        case .top_rated:
            newResponse.title = Localizable.text(.top_rated)
        }
        return newResponse
    }
    
    func removeAllList(){
        self.tvShows.removeAll()
        self.movies.removeAll()
        self.allMoviesTV.removeAll()
    }

    func loadData(){
        //Show list save
        if let movies = self.retrieveData(model: [MoviesModel].self, modelString: .MoviesData),
              let moviesResult = self.retrieveData(model: [CollectionMoviesModel].self, modelString: .MovieResultData),
              movies.count > 0  {
            
            self.removeAllList()
            self.tvShows = movies.filter({$0.type == encryptData(List.tv.rawValue)})
            self.movies = movies.filter({$0.type == encryptData(List.movie.rawValue)})
            self.updateMovieOrTvShow(list: self.tvShows, type: .tv, movieResul: moviesResult, title:Localizable.text(.favorites), completion: { item, index in
                guard let item = item, let index = index else { return }
                self.tvShows[index] = item
            })
            
            self.updateMovieOrTvShow(list: self.tvShows, type: .tv, movieResul: moviesResult, title:Localizable.text(.top_rated), completion: { item, index in
                guard let item = item, let index = index else { return }
                self.tvShows[index] = item
            })
            
            self.updateMovieOrTvShow(list: self.movies, type: .movie, movieResul: moviesResult, title:Localizable.text(.favorites), completion: { item, index in
                guard let item = item, let index = index else { return }
                self.movies[index] = item
            })
            
            self.updateMovieOrTvShow(list: self.movies, type: .movie, movieResul: moviesResult, title: Localizable.text(.top_rated), completion: { item, index in
                guard let item = item, let index = index else { return }
                self.movies[index] = item
            })
            
            self.allMoviesTV.append(SubCategoryModel.init(list: self.movies, title: Localizable.text(.films)))
            self.allMoviesTV.append(SubCategoryModel.init(list: self.tvShows, title: Localizable.text(.tv_shows)))
            DispatchQueue.main.async {
                self.movieData = CategoryModel(moviesTV: self.allMoviesTV)
            }
            
        } else {
            DispatchQueue.main.async {
                self.messageError = Localizable.text(.empty_list_movie_tv)
            }
        }

    }
    
    func updateMovieOrTvShow(list:[MoviesModel], type:List, movieResul:[CollectionMoviesModel], title:String, completion:updateItem){
        let filterMovieResult = movieResul.filter({($0.type ?? "") == encryptData(type.rawValue) && $0.title == encryptData(title)})
        var updateItem:MoviesModel? = list.filter({($0.title ?? "") == encryptData(title) }).first
        updateItem?.results = filterMovieResult
        if let index = list.firstIndex(where: {($0.title ?? "") == encryptData(title)}),
           let updateItem = updateItem
        {
            completion(updateItem, index)
        } else {
            completion(nil, nil)
        }
    }
    
    private func encryptData(_ value:String) -> String {
        guard let encryptResult = EncryptionTool.share.encrypString(string:value) else {
            return ""
        }
        return encryptResult
    }
}

//Core data
extension MovieViewModel {
    //
    //Save core data
    //encrypt data
    func createData(from movies:[MoviesModel]){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              movies.count > 0
        else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let moviesDataEntity = NSEntityDescription.entity(forEntityName: "MoviesData", in: managedContext)
        let moviesResultEntity = NSEntityDescription.entity(forEntityName: "MovieResultData", in: managedContext)
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
        movies.forEach({ i in
            let user = NSManagedObject(entity: moviesDataEntity!, insertInto: managedContext)
            user.setValue(encryptData(i.title ?? ""), forKeyPath: "title")
            user.setValue(encryptData(i.type ?? ""), forKey: "type")
            i.results?.forEach({ movie in
                let user = NSManagedObject(entity: moviesResultEntity!, insertInto: managedContext)
                user.setValue(encryptData(movie.posterPath ?? ""), forKeyPath: "poster_path")
                user.setValue(encryptData("\(String(describing: movie.voteCount?.toInt()))"), forKey: "vote_count")
                user.setValue(encryptData(i.type ?? ""), forKey: "type")
                user.setValue(encryptData("\(String(describing: movie.id?.toInt()))"), forKeyPath: "id")
                user.setValue(encryptData(i.title ?? ""), forKey: "title")
            })
        })
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveData<MC : Decodable>(model : MC.Type?, modelString:catalogModel)  -> MC?  {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelString.rawValue)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let jsonData = ConvertNSManagedObjectToData.convertToData(moArray: result as! [NSManagedObject])
            let decoder = JSONDecoder()
            let model = try decoder.decode(model!.self, from: jsonData)
            return model
        } catch let error {
            print("Failed \(error)")
            return nil
        }
        
    }
        
    func deleteData(model:catalogModel){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: model.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
       
        do
        {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        }
        catch let error
        {
            print(error)
        }
         
    }
    
}
