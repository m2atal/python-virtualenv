# Utilisation de python sur le cluster étudiant

Il est conseillé d'utiliser un environnement virtuel python. En effet celui-ci vous permettra d'avoir un contrôle total dessus.
De plus, il est fort probable qu'il faille utiliser certaines version spécifiques de CUDA ou d'un paquet python. Vous pourrez donc disposer d'un environnement virtuel pour chaque besoin.

En ce jour du 1 février de l'an 2020, `conda` n'étant pas disponible, nous allons voir comment utiliser `virtualenv`

# Installation préalable.

Installation des paquet nécessaires

`pip install --user --upgrade virtualenv`


## Création d'un environnement virtuel python 2.7 nommé nom_virtualenv_27
`virtualenv -p /usr/bin/python2.7 nom_virtualenv_27`

## Création d'un environnement virtuel python 3.7 nommé nom_virtualenv_37
`virtualenv -p /usr/bin/python3.7 nom_virtualenv_37`


# Utilisation d'un environnement virtuel

On commence par l'activer : `source nom_virtualenv_37/bin/activate`  

Par la suite on pourra installer les paquets python en utilisant les l'outil `pip`

Pour désactiver l'environnement virtuel: `deactivate`


## Utilisation d'un environnement virtuel avec jupyter

C'est bien beau tout ça, mais c'est galère à utiliser les environnements virtuel avec des scripts !
En effet, c'est pour cela que l'on va les combiner avec des notebooks jupyter.
On pourra facilement changer d'environnements.

C'est quoi Jupyter ? Non on parle pas de planète mais bien d'un Web IDE bien pratique pour les TP 

Voir [ici](https://github.com/m2atal/notebook-distant) comment les utiliser sur le cluster étudiant

## Pré-requis

Avoir jupyter d'installé sur votre utilisateur (c-a-d en dehors des environnements virtuels)


`pip install --user --upgrade jupyter`


Comment ajouter un environnement virtuel à Jupyter (kernel)

Dans votre environnement virtuel ajouter le paquet suivant: `pip install ipykernel`  
Une fois installé lancer la commande suivante: `ipython kernel install --user --name=py_37`.  
* À noter que le nom affiché sera celui passé en paramètre du `--name` *  


Chef, je comprends pas j'ai redémarré le Jupyter et le kernel que j'ai ajouté, bah c'est pas le bon !!

Il arrive que lors de l'ajout du kernel, celui-ci crée un mauvais lien vers le noyau python à utiliser.
Pour régler ce problème, c'est pas trop compliqué.

* 1ère étape: regarder la version du python à utiliser  
  * activer l'environnement virtuel et marquer `which python`
  * noter le chemin
* 2ème étape:
 * Ouvrir le fichier suivant : `~/.local/share/jupyter/kernels/mon_environnement_virtuel/kernel.json`
 * Celui-ci devrait ressembler à ca:  
```[json]
{
 "argv": [
  "path_to_python",
  "-m",
  "ipykernel_launcher",
  "-f",
  "{connection_file}"
 ],
 "display_name": "nom_du_kernel",
 "language": "python"
}
```

La ligne qui nous intéresse est celle du `path_to_python`. Celle-ci doit correspondre au chemin vers l'environnement virtuel. Si celle-ci ne correspond pas alors il faut la remplacer.


 


Comment désintaller un kernel jupyter ?

`jupyter kernelspec uninstall le-nom-du-kernel`


## Paquet python requis pour vos différents TP


Quelle version de torch pour quelle version de cuda ? [ici](https://pytorch.org/get-started)


pip install numpy pandas torch torchvision sidekit s4d

