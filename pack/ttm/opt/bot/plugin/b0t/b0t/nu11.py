class NullBot:
    pass
class NullPopulation:
    pass
class NullCorpus:
    pass
class NullWorld:
    pass
class NullReality:
    pass
class NullUniverse:
    pass

########################
# see naive.py to understand what the following implies:

# a population is a sequence or set of Bots
# a World has a population, a Reality and a Corpus
# a cluster is a sequence or set of worlds
#   a a cluster might have clusters
# a universe is reality and a cluster


# how they operate:
# a world might perform() which makes:
#   1. reality touch its population
#   2. world iterate over population

# a Universe might perform(), making all
# the Worlds in its cluster perform()

# realities, worlds, populations, bots, etc might
# be static or change in each iteration.

# the main goal of the soul swarm is to train the
# Bots (for cognitive computing), but any other
# class (Population, Realitie, etc) might evolve,
# might change over the iterations and touches,
# and might be subjected to optimization of an
# arbitrary fitness.

# thus, any of the classes might perform,
# be it because it is linked to another class that
# is performing, or because it is capable of performing
# and was directly called to perform().

