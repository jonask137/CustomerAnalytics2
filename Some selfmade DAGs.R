#Solution 1

library(DiagrammeR)
grViz("
digraph boxes_and_circles {

  # a 'graph' statement
  graph [overlap = true, fontsize = 10]

  # several 'node' statements
  node [shape = circle,
        fontname = Helvetica,
        style = filled,
        fillcolor = darkgreen]
  X; Y; W; V

  node [shape = circle,
        fontname = Helvetica,
        style = filled,
        fillcolor = purple]
  Z

  # several 'edge' statements
  X -> Y -> W
  Z -> W
  X -> Z -> V
}
")

#Solution 2

nodes <- create_node_df(n = 5 #no. of nodes
                        ,label = c("X","Y","Z","W","V")
                        ,color = "black"
                        ,fillcolor = c("darkred",rep("darkgreen",4)
)

edges <- create_edge_df(from = c("X", "X", "Y", "Z","Z"),
                        to = c("Y", "Z", "W", "W","V"))

my_graph <- create_graph(nodes_df = nodes, edges_df = edges)

render_graph(my_graph)

#Solution 3

library(ggdag)
#Generating the relationships
dag <- dagitty::dagitty("dag {
    X -> Y -> W
    X -> Z -> W
    X -> Z -> V
  }"
)
tidy_dag <- tidy_dagitty(dag)
#Adding information on the color
tidy_dag$data <- dplyr::mutate(tidy_dag$data,
                               colour = ifelse(tidy_dag$data$name == "Z"
                                               ,"Reference point"
                                               ,ifelse(tidy_dag$data$name == "X","Parent"
                                                       ,ifelse(tidy_dag$data$name %in% c("V","W"),"Descendent","Non descendents"))))
#Making the plot
tidy_dag %>%
  ggplot(aes(
    x = x,
    y = y,
    xend = xend,
    yend = yend
  )) +
  geom_dag_point(aes(colour = colour)) +
  geom_dag_edges() +
  geom_dag_text() +
  theme_dag()
