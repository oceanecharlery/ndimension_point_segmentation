# TP2 - KMEANS - IMAGE

clear;
pkg load image;

# Lecture de l'image et redimensionnement :
I = double(imread('Silhouette.jpg'));
I = imresize(I,[250 250]);
# Passer l'image à plat
A = reshape(I,[size(I,1) * size(I,2), size(I,3) ]);
[rows,cols] = size(A);

# Paramètres :
k = 8; # Nombre de classes
previous_points = ones(k, cols);
points = zeros(k, cols);
means = zeros(k,size(A,2));
e =  0.0001;
max_iterations = 20;

# 1. Choix des k points aléatoirement
for i = 1:k
  n = randi(rows); # Choisir une ligne aléatoire dans A
  points(i,:) = A(n,:); # Stocker le pixel qui se trouve à cette ligne dans points[]
end


# Tant que l'algorithme ne converge pas
while abs(previous_points(:,:) - points(:,:)) > e && max_iterations > 0
  disp(max_iterations);
  max_iterations = max_iterations - 1;
  disp('distance between current points and previous point : ');
  disp(abs(previous_points(:,:) - points(:,:)));

  # 2. Affecter chaque point de A à son centroid le plus proche

  # Stocker la distance d'un pixel par rapport à chaque y(k) (pour sélectionner
  # la plus petite) :
  distances = [];
  # Stocker la classe (label) de chaque pixel :
  classes = [];

  # Boucler sur tous les points de A
  for i = 1:size(A,1)
    # Pour chaque classe
    for centroid = 1:k
      # Calculer la distance entre le point courant et chacun des y(k)
      distances(centroid) = norm(A(i,:)-points(centroid,:));
    end
    # Affecter le ième point de A à la classe qui minimise la distance :
    classes(i) = find(distances==(min(distances)),1);
  end

  # 3. Sélection du pixel barycentrique :

  for centroid = 1:k
    # Récupérer les pixels d'une même classe
    k_indexes = find(classes==centroid);
    means(centroid,:) = 0;

    # Pour chaque pixel faire la moyenne du rouge, du vert et du bleu :
    for pixel = 1:size(k_indexes,2)
      means(centroid,:) += A(k_indexes(pixel),:);
    end
    means(centroid,:) = means(centroid,:) / size(k_indexes,2);
  end

  previous_points(:,:) = points(:,:);
  points(:,:) = means(:,:);
end


# Visualisation
for pixel = 1:size(classes,2)
  O(pixel,:) = means(classes(pixel),:);
end

O = reshape(O, size(I));

figure(1);
subplot(1,2,1);
imshow(uint8(I));
title("image originale");

subplot(1,2,2);
imshow(uint8(O));
title({
    ['k = ' num2str(k) ]
    ['epsilon = ' num2str(e) ]
    ['iterations = ' num2str(20 - max_iterations) '   max iterations = 20']
    }, 'FontSize', 10);

