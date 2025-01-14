//
//  TableViewController.swift
//  Movies
//
//  Created by Zeiad on 08/01/2025.
//

import UIKit

class TableViewController: UITableViewController , AddMovieProtocol{
    
    
    var movies: [Movie] = []

    @IBOutlet weak var myNavigationItems: UINavigationItem!
    override func viewDidLoad() {
        let rightButton = UIBarButtonItem(
            title: "Add Movie", style: .plain, target: self,
            action: #selector(addMovieView))
        self.navigationItem.rightBarButtonItem = rightButton
        super.viewDidLoad()
        movies = DBManager.shared.getAllMovies()
    }
    @objc func addMovieView() {
        let vc =
            self.storyboard?.instantiateViewController(
                withIdentifier: "addMovieView") as! AddViewController
        vc.firstVc = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func addMovie(movie: Movie) {
        
        DBManager.shared.insert(movie: movie)
        movies = DBManager.shared.getAllMovies()
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = movies[indexPath.row].title
        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            var alert = UIAlertController(title: "deleting movie", message: "are you sure to delete this movie?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { UIAlertAction in
                DBManager.shared.delete(movieId: self.movies[indexPath.row].id!)
                self.movies = DBManager.shared.getAllMovies()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            self.present(alert, animated: true)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        let vc =
            self.storyboard?.instantiateViewController(
                withIdentifier: "details") as! ViewController
        vc.movie = movies[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
