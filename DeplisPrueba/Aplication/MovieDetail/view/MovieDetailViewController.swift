//
//  MovieDetailViewController.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 10/11/22.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    public var information: Result?
    
    @IBOutlet weak var imagePoster: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelOriginalTitle: UILabel!
    
    @IBOutlet weak var labelRealseDate: UILabel!
    @IBOutlet weak var labelAdult: UILabel!
    
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var labelPopuluty: UILabel!
    @IBOutlet weak var labelGenres: UILabel!
    @IBOutlet weak var labelDescriptions: UILabel!
    
    @IBOutlet weak var detailContent: UIView!
    @IBOutlet weak var collectionViewCompanies: UICollectionView!
    var moreInformation: MovieDetailReponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePoster.image = UIImage(named: "logo")
        
        imagePoster.downloadedFrom(link:"http://image.tmdb.org/t/p/w500\(information?.backdropPath ?? "")", contentMode: .scaleToFill, animated: true)
        
        labelTitle.text = information?.title ?? "Sin titulo"
        labelOriginalTitle.text = "(\(information?.originalTitle ?? "Sin titulo original"))"
        
        
        labelAdult.text = (information?.adult ?? false) ? "Sí" : "No"
        labelRealseDate.text = information?.releaseDate ?? "Sin fecha de lanzamiento"
        rate.text = "✭ \(information?.voteAverage ?? 0.0)"
        
        detailContent.clipsToBounds = true
        detailContent.layer.cornerRadius = 12
        detailContent.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        imagePoster.clipsToBounds = true
        imagePoster.layer.cornerRadius = 12
        imagePoster.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        labelGenres.text = "Generos"
        
        labelDescriptions.text = (information?.overview ?? "Sin descripcion").isEmpty ? "Sin descripcion" : (information?.overview ?? "Sin descripcion")
        
        
        collectionViewCompanies.register(UINib(nibName: "CompanyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CompanyCollectionViewCell.identifier)
        
        collectionViewCompanies.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        
        collectionViewCompanies.collectionViewLayout = layout
        
        
        ServiceCoordinator.getDetailMovie(movieID: String(information?.id ?? 0)){ movieDetailReponse in
            

            DispatchQueue.main.async {
                self.moreInformation = movieDetailReponse
                
                var generesText = ""
                
                movieDetailReponse?.genres?.forEach({ genre in
                    generesText += "\(genre.name), "
                })
                
                self.labelGenres.text = generesText
                
                self.collectionViewCompanies.reloadData()
            }
            
        }
        
    }

    @IBAction func onBackCliked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

}

extension MovieDetailViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreInformation?.productionCompanies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCollectionViewCell.identifier, for: indexPath) as! CompanyCollectionViewCell
        
        cell.setupInformation(information: moreInformation?.productionCompanies?[indexPath.row])
        
        return cell
    }
    
    
}

extension  MovieDetailViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30 , height: 30)
    }

    
}
