//
//  SmoothTableView.swift
//  Demo
//
//  Created by WangBo on 2020/4/23.
//  Copyright © 2020 wangbo. All rights reserved.
//

import UIKit

class SmoothTableView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ui()
    }
    
    private func ui() {
        self.tableView.register(UINib.init(nibName: SmoothTableViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: SmoothTableViewCell.identifier)
    }
    
    
    func startCustomTransitionAnimation(){
        UIGraphicsBeginImageContextWithOptions(self.navigationController!.view.bounds.size, true, 0)
        self.navigationController!.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let coverImage = UIGraphicsGetImageFromCurrentImageContext()
        
        let coverImageView = UIImageView.init(image: coverImage)
        coverImageView.frame = self.navigationController!.view.convert(self.view.frame, from: nil)
        self.navigationController!.view.addSubview(coverImageView)
        UIView.animate(withDuration: 1, animations: {
            var transfrom = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
            transfrom = transfrom.rotated(by: CGFloat.pi/2)
            coverImageView.alpha = 0
            coverImageView.transform = transfrom
        }) { (_) in
            coverImageView.removeFromSuperview()
        }
    }
    
    func startCustomTransitionAnimation(originView:SmoothTableViewCell){
        UIGraphicsBeginImageContextWithOptions(originView.icon.bounds.size, true, 0)
        originView.icon.layer.render(in: UIGraphicsGetCurrentContext()!)
        let coverImage = UIGraphicsGetImageFromCurrentImageContext()
        
        let coverImageView = UIImageView.init(image: coverImage)
        let position = self.tableView.convert(originView.frame.origin, to: self.navigationController!.view)
        coverImageView.frame = CGRect.init(x: position.x + 10, y: position.y + 10, width: 80, height: 80)
        let backV = UIView.init(frame: self.view.frame)
        backV.backgroundColor = .white
        self.view.addSubview(backV)
        self.navigationController!.view.addSubview(coverImageView)
        
        UIView.animate(withDuration: 0.35, animations: {
            //coverImageView.alpha = 0
            coverImageView.frame = CGRect.init(x: 0, y: 64, width: self.navigationController!.view.bounds.width, height: 200)
        }) { (_) in
            coverImageView.removeFromSuperview()
            let vc = SmoothTableDetail()
            self.navigationController?.pushViewController(vc, animated: false)
            backV.removeFromSuperview()
        }
    }

}
extension SmoothTableView:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SmoothTableViewCell.identifier) as? SmoothTableViewCell{
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SmoothTableViewCell{
            self.startCustomTransitionAnimation(originView: cell)
        }else{
            self.startCustomTransitionAnimation()
        }

    }
}
