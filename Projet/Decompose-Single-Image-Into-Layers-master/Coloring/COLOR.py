from numpy import *
#from matplotlib import *
import Tkinter as tk
from PIL import Image, ImageTk

layers = []


def a2img(lay):
    colored_composite = lay
    colored_composite = colored_composite.round().clip( 0, 255 ).astype( uint8 )

    return Image.fromarray( colored_composite )
 
def coloring(target_layer_index, target_rvb,mult_A):
    global layers
    print mult_A
    target_layer = layers[target_layer_index]
    out_layers = layers
    target_layer[:,:,:3] = target_rvb*ones( layers[0].shape )[:,:,:3]
    target_layer[:,:,3] = mult_A*target_layer[:,:,3]
    out_layers[target_layer_index] = target_layer

    layers = out_layers

def composite_layers():
    #layers = asfarray( layers )
    
    ## Start with opaque white.
    out = 255*ones( layers[0].shape )[:,:,:3]

    
    for layer in layers:    
        out += layer[:,:,3:]/255.*( layer[:,:,:3] - out )
    
    return out






def init_fenetre(fenetre,img_nb,img):

    global layers

    def terminer():
       
        fenetre.quit()
 

    def compute_color(R,V,B,A,D,canva):
       
        coloring(int(selector_layer.get()),[int(R)*2.55,int(V)*2.55,int(B)*2.55],(int(A)/50.0)**4)
        


        new_img = a2img(composite_layers())
        photo=ImageTk.PhotoImage(new_img)
        canva.create_image(0, 0, anchor=tk.NW, image=photo)
        canva.image = photo





    f_general = tk.PanedWindow(fenetre, orient=tk.HORIZONTAL)
    f_general.pack(side=tk.TOP, expand=tk.Y, fill=tk.BOTH, pady=2, padx=2)

    #photo = ImageTk.PhotoImage(file="Parc.jpg")
    photo = ImageTk.PhotoImage(img)
    canvas = tk.Canvas(f_general,width=1023, height=575)
    canvas.create_image(0, 0, anchor=tk.NW, image=photo)
    canvas.image = photo
    canvas.pack()

    
    f_general.add(canvas)
    titre_R = tk.LabelFrame(f_general, text="Rouge", padx=0, pady=0)
    titre_R.pack(fill="both", expand="yes")
    f_general.add(titre_R)
    titre_V = tk.LabelFrame(f_general, text="Vert", padx=0, pady=0)
    titre_V.pack(fill="both", expand="yes")
    f_general.add(titre_V)
    titre_B = tk.LabelFrame(f_general, text="Bleu", padx=0, pady=0)
    titre_B.pack(fill="both", expand="yes")
    f_general.add(titre_B)
    titre_A = tk.LabelFrame(f_general, text="Alpha", padx=0, pady=0)
    titre_A.pack(fill="both", expand="yes")
    f_general.add(titre_A)
    titre_D = tk.LabelFrame(f_general, text="Diffusion", padx=0, pady=0)
    titre_D.pack(fill="both", expand="yes")
    f_general.add(titre_D)



    val_R = tk.DoubleVar() 
    scale_R = tk.Scale(titre_R, variable=val_R)
    scale_R.pack()

    val_V = tk.DoubleVar() 
    scale_V = tk.Scale(titre_V, variable=val_V)
    scale_V.pack()

    val_B = tk.DoubleVar() 
    scale_B = tk.Scale(titre_B, variable=val_B)
    scale_B.pack()

    val_A = tk.DoubleVar() 
    scale_A = tk.Scale(titre_A, variable=val_A)
    scale_A.pack()

    val_D = tk.DoubleVar() 
    scale_D = tk.Scale(titre_D, variable=val_D)
    scale_D.pack()
 
    def actualize_layer(index):
     
        index = int(index)
        scale_R.set(layers[index][1][1][0])
        scale_V.set(layers[index][1][1][1])
        scale_B.set(layers[index][1][1][2])
        scale_A.set(50)
        scale_D.set(0)

    bouton_compute=tk.Button(f_general, text="Appliquer modif", command= lambda: compute_color(scale_R.get(),scale_V.get(),scale_B.get(),scale_A.get(),scale_D.get(),canvas))
    bouton_compute.pack()
    f_general.add(bouton_compute)
    selector_layer = tk.Spinbox(f_general, from_=0, to=img_nb-1)
    selector_layer.pack()
    f_general.add(selector_layer)
    bouton_select_layer=tk.Button(f_general, text="Choisir ce calque", command= lambda:actualize_layer(selector_layer.get()))
    bouton_select_layer.pack()
    f_general.add(bouton_select_layer)
    bouton_quit=tk.Button(f_general, text="Sauver et Quitter", command=terminer)
    bouton_quit.pack()
    f_general.add(bouton_quit)
    f_general.pack()

    
    actualize_layer(0)


    

def img_management(img_nb, img_path):

    #interpretation des images calques pour creer LAYERS
    global layers 
    layers = []
    for layer_index in range(0,img_nb):

        layer_path = img_path + '-layer'
        if layer_index <= 9:
            layer_path += '0'
        layer_path += str(layer_index) + '.png'

        layers.append(asfarray(Image.open( layer_path ).convert( 'RGBA')))
    
    layers = asfarray( layers )
    layers_save = list(layers)

    #initialisation de l'interface
    first_img = a2img( composite_layers() )
    fenetre = tk.Tk()
    init_fenetre(fenetre,img_nb,first_img)  
    
    

    

    #target_color = [255,0,0]
    #colored_layers = coloring(layers,1,target_color)
    

    fenetre.mainloop()
    final_img = a2img(layers)
    final_img.save( img_path +'-composite-COLORED.png')

 
        


if __name__ == '__main__':
    import sys
    
    def usage():
        print >> sys.stderr, "Usage:", sys.argv[0], "--color-number le_nombre_de_calques --root-name path/to/nomCalquesSans-layerXX"
        print >> sys.stderr, "NOTE: va utiliser les fichier root-name-layer00 a root-name-layer(color-numb - 1)"
        
        sys.exit(-1)
    
    args = list( sys.argv[1:] )
    
    try:
        
        color_number = None
        try:
            index = args[:-1].index( '--color-number' )
            color_number = int(args[ index+1 ])
            
        except ValueError: pass
        
        root_name = None
        try:
            index = args[:-1].index( '--root-name' )
            root_name = str( args[ index+1 ] )
            
        except ValueError: pass
        '''
        too_small = None
        try:
            index = args[:-1].index( '--too-small' )
            too_small = int( args[ index+1 ] )
            del args[ index : index+2 ]
        except ValueError: pass
        '''
    except Exception:
        usage()
    
    if len( args ) != 4: 
        usage()
    
    
    img_management(color_number,root_name)
