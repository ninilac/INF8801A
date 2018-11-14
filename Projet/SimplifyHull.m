function newHull = SimplifyHull(hull)
    

retirer une arrete :
    liste1,liste2,compte vide
    parcourir les arretes (de sommets S1 et S2)
        faces = ensenmble de face liees a S1 ou S2
        % now find a point, so that for each face in related_faces will 
               % create a positive volume tetrahedron using this point.
        % minimize c*x. w.r.t. A*x<=b
        n-list,n2-list,n3,s-list vide
        -» parcours chaque face (sommets s1 s2 s3) de faces
            s-list append s1,s2,s3
            n = cross(s2-s1,s3-s1)
            n = n/(sqrt(n.n)) %normalisation
            n-list append n
            n2-list append n.s1
            n3 += n
        
        res = cvxopt.solvers.lp(n3,n-list,n2-list,solver=glpk ) %quest ce ?
        si optimal (nouveau_pt):
            volume = 0
            parcours chaque_face(s1,s2,s3) dans s-liste 
                volume += vol tetrahedre [nouveau_pt,s1,s2,s3]
            liste1 append compte,volume,S1,S2)
            liste2 append nouveau_pt
            compte++
    %deux options possibles:
    %-----------------------------
    si liste1 non vide
        
    (a completer mais en gros :
    utilise liste1 et 2 pour construire le nouveau hull)
    
            
            
        


end
