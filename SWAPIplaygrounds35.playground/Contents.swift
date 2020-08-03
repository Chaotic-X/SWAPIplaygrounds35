import UIKit
// 1 - Prepare URL

// 2 - Contact server

// 3 - Handle errors

// 4 - Check for data

// 5 - Decode Person from JSON
//MARK: -Models
struct Person: Decodable {
  let name: String
  let homeworld: String
  let films: [URL]
}

struct Film: Decodable {
  let title: String
  let opening_crawl: String
  let release_date: String
}

//MARK: -Model Controller

class SwapiService {
  
  //MARK: -Static Properties
  static let baseURL = URL(string: "https://swapi.dev/api/")
  static let personEndPoint = "people"
  static let filmsEndPoint = "films"
  
  static func fetchPerson(withID personID: Int, completion: @escaping(Person?) -> Void) {
    //Create the URL
    guard let baseURL = baseURL else { return completion(nil)}
    let personURL = baseURL.appendingPathComponent(personEndPoint)
    let finalURL = personURL.appendingPathComponent("\(personID)")
    print(finalURL)
    
    //Fetch your Data from the API
    //
    URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
      //Check for errors
      if let error = error {
        print("Error #1 in \(#function) : \(error.localizedDescription) \n---\n \(error)")
      } else {
        guard let data = data else { return completion(nil)}
        do {
          let person = try JSONDecoder().decode(Person.self, from: data)
          return completion(person)
        } catch {
          print("Error #2 in \(#function) : \(error.localizedDescription) \n---\n \(error)")
          return completion(nil)
        }
      }
    }.resume() //End of URLSession func so please resume it HERE
  } //End of FetchPerson
  
  //MARK: - FetchFilms
  static func fetchFims(with url: URL, completion: @escaping(Film?) -> Void) {
    //We pass in the URL form the fetchPerson func so we just go straight to the URLSession
    print(url)
    URLSession.shared.dataTask(with: url) { (data, _, error) in
      if let error = error {
        print("Error #1 for Films in \(#function) : \(error.localizedDescription) \n---\n \(error)")
      } else {
        guard let data = data else {return completion(nil)}
        do {
          let films = try JSONDecoder().decode(Film.self, from: data)
          return completion(films)
        } catch {
          print("Error #2 for Films in \(#function) : \(error.localizedDescription) \n---\n \(error)")
          return completion(nil)
        }
      }
    }.resume()
  } //End of FetchFilms
} //End of Class

SwapiService.fetchPerson(withID: 1) { (persons) in
  guard let persons = persons else {return}
  print(persons.name)
//  print(persons.homeworld)
  persons.films.forEach { (url) in
    SwapiService.fetchFims(with: url) { (film) in
      guard let film = film else {return}
      print("\n"+"\n"+film.title+"\n")
      print(film.release_date+"\n")
      print(film.opening_crawl)
    }
  }
}

