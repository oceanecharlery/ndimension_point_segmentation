# TP2 - KMEANS - NDIMENSIONS

clear;

# Chargement des données
# A = load("classif_data/gmm3d.asc");

# Décommenter les deux lignes suivantes pour exécuter l'algo sur n dimensions :
n = 5;
A = rand(10000,n);

[rows,cols] = size(A);

# Paramètres :
k = 3; # Nombre de classes
previous_points = ones(k, cols);
points = zeros(k, cols);
means = zeros(k,size(A,2));
e =  0.0001;
max_iterations = 20;

# 1. Choix des k points aléatoirement
for i = 1:k
  n = randi(rows); # Choisir une ligne aléatoire dans A
  points(i,:) = A(n,:); # Stocker le point qui se trouve à cette ligne dans points[]
end

# Tant que l'algorithme ne converge pas
while abs(previous_points(:,:) - points(:,:)) > e && max_iterations > 0
  disp(max_iterations);
  max_iterations = max_iterations - 1;
  disp('distance between current points and previous point : ');
  disp(abs(previous_points(:,:) - points(:,:)));


  # 2. Affecter chaque point de A à sa partition la plus proche

  # Stocker la distance d'un point par rapport à chaque y(k) (pour sélectionner
  # la plus petite)
  distances = [];
  # Stocker la classe (label) de chaque point
  classes = [];

  # Boucler sur tous les points de A
  for i = 1:rows
    # Pour chaque classe
    for yk = 1:k
      # Calculer la distance entre le point courant et chacun des y(k)
      distances(yk) = norm(A(i,:)-points(yk,:));
    end
    # Affecter le ième point de A à la classe qui minimise la distance :
    classes(i) = find(distances==(min(distances)));
  end


  # 3. Sélection du point qui minimise le barycentre du cluster comme nouveau centroid

  for i = 1:k
    k_indexes = find(classes==i);
    means(i,:) = 0;

    for j = 1:size(k_indexes,2)
      means(i,:) += A(k_indexes(j),:);
    end
    means(i,:) = means(i,:) / size(k_indexes,2);
  end

  previous_points(:,:) = points(:,:);
  points(:,:) = means(:,:);
end



# Visualisation
# (Le résultat ne peut pas être visualisé pour n > 3)

figure(1);

for i=1:k
  k_indexes = find(classes==i);
  # Plot cluster points (2D) :
  scatter(A(k_indexes(:),1), A(k_indexes(:),2));

  # Décommenter pour n = 3
  # scatter3(A(k_indexes(:),1), A(k_indexes(:),2), A(k_indexes(:),3));
  hold on;
end

# Plot (2D) current centroids :
plot(points(:,1), points(:,2), '+', 'MarkerSize',8,'LineWidth',2, 'Color',[0,0,0]);

# Décommenter pour n = 3
# plot3(points(:,1), points(:,2), points(:,3), '+', 'MarkerSize',8,'LineWidth',2, 'Color',[0,0,0]);
hold on;

# Plot previous centroids :
plot(previous_points(:,1), previous_points(:,2), '+', 'MarkerSize',3,'LineWidth',2, 'Color',[1,0,0]);

# Décommenter pour n = 3
# plot3(previous_points(:,1), previous_points(:,2), previous_points(:,3), '+', 'MarkerSize',8,'LineWidth',2, 'Color',[0,0,0]);

title({
    ['k = ' num2str(k) ]
    ['data dimensions = ' num2str(cols) ]
    ['epsilon = ' num2str(e) ]
    ['iterations = ' num2str(20 - max_iterations) '   max iterations = 20']
    }, 'FontSize', 10);

