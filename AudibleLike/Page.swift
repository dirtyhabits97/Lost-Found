//
//  GuideObject.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 4/24/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

class Page {
    let title: String
    let message: String
    let imageName: String
    
    init(_ title: String, _ message:String, _ imageName: String) {
        self.title = title
        self.message = message
        self.imageName = imageName
    }
    
    static func getPages() -> [Page] {
        let firstPage = Page("Ayúdanos a ayudar a otros","Más del 60% de las personas reportadas como perdidas no son encontradas. Tú puedes hacer la diferencia.", "page1")
        let secondPage = Page("Descripción detallada", "Haz tap en cualquiera de las personas listadas para ver información detallada que te podría ayudar a identificarla.", "page2")
        let thirdPage = Page("Otra forma de ver la información","Haz tap en la esquina superior derecha para cambiar el modo de vista.", "page3")
        let fourthPage = Page("Modo Mapa","El modo mapa te permite ver los lugares en el que las personas fueron vistas por última vez.", "page4")
        let guideArray = [firstPage, secondPage, thirdPage, fourthPage]
        return guideArray
    }
}
