// remove UIKit and add Fundation later
import UIKit

struct ResponseData: Decodable{
    let name: String
    let job: String
    let id: String
    let createdAt: String
}

protocol ReciveResponse{
    func didReciveResoponse(userData: ResponseData)
}

class Network{
    var delegate: ReciveResponse?
    
    func createRequest(url: URL, parametars: [String: Any]) -> URLRequest{
        // Create the Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parametars, options: [])
        }catch{
            print("Body error: \(error.localizedDescription)")
        }
        
        return request
    }
    
    
    func getResponse(request: URLRequest) -> Void{
        // This is sending Request and waiting for Response
        // request is referred to as a task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("Getting the Response")
            
            if let err = error{
                print("HTTP Request error: \(err.localizedDescription)")
                return
            }
            
            if let userData = data{
                self.parseJSON(data: userData)
            }
        }.resume()
    }
    
    func parseJSON(data: Data){
        let decoder = JSONDecoder()
        
        do{
            let responseData = try decoder.decode(ResponseData.self, from: data)
            
            print(responseData)
            
            delegate?.didReciveResoponse(userData: responseData)
            
        }catch{
            print("Decoding JSON error: \(error.localizedDescription)")
        }
    }
}



let urlString: String = "https://reqres.in/api/users"

let paramaters: [String: Any] = [
    "name": "morpheus",
    "job": "leader",
]

let network = Network()


if let url = URL(string: urlString){
    let request = network.createRequest(url: url, parametars: paramaters)
    network.getResponse(request: request)
}
