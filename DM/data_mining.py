import pandas as pd
import cluster as clu
import graphs as gps
from mysql.connector import IntegrityError, MySQLConnection
import argparse
import config
import pyinputplus as pyip

def str2bool(v):
  if isinstance(v, bool):
    return v
  if v.lower() in ('yes', 'true', 't', 'y', '1'):
    return True
  elif v.lower() in ('no', 'false', 'f', 'n', '0'):
    return False
  else:
    raise argparse.ArgumentTypeError('Boolean value expected.')

def validate(df, args):
  gps.RatingDist(df['rating'])
  gps.RatingDist(df['numPages'])
  gps.RatingDist(df['numRatings'])
  trial = df[['rating', 'numRatings']]
  if args.cap is not None:
    trial = trial[~(trial.numRatings>args.cap)]
    print(trial.idxmax())
    trial.drop(trial.rating.idxmax(), inplace = True)
    trial.drop(trial.numRatings.idxmax(), inplace = True)
    
  gps.scatterPlot(trial['rating'], trial['numRatings'], "Rating vs NumRatings")
  gps.scatterPlot(df['rating'], df['numPages'], "Rating vs NumPages")
  print("Generating elbow curve well take some time.....\n")
  gps.elbowGraphKmean(trial['rating'], trial['numRatings'])
  print("Visualizing KMean clustering scatter plot will take some time.....\n")
  gps.sactterPlotKmeanLables(trial['rating'], trial['numRatings'], 5)

def segregation(data):
    values = []
    for val in data.rating:
        if val>=0 and val<=1:
            values.append("Between 0 and 1")
        elif val>1 and val<=2:
            values.append("Between 1 and 2")
        elif val>2 and val<=3:
            values.append("Between 2 and 3")
        elif val>3 and val<=4:
            values.append("Between 3 and 4")
        elif val>4 and val<=5:
            values.append("Between 4 and 5")
        else:
            values.append("NaN")
    return values

def get_book():
  book = pyip.inputStr('Enter book: ')
  return book

def main():
  parser = argparse.ArgumentParser(description='Data Mining.')
  parser.add_argument('-v', '--validate', dest='validate', type=str2bool, const=False, nargs='?', default=False, help='validate dataset using K-Mean (default: false)')
  parser.add_argument('-cap', '--cap', dest='cap', type=int, default=None, help='Max bound to use for validation')
  args = parser.parse_args()
  
  mydb = MySQLConnection(**config.credentials)

  df = pd.read_sql('SELECT Name, numRatings, rating, numPages FROM Book', con=mydb)
  df['Ratings_Dist'] = segregation(df)
  if args.validate == True:
    validate(df, args)
  else:
    cl = clu.Cluster(df)
    cl.training()
    while True:
      book = get_book()
      cl.print_similar_books(book)
   
  mydb.close()

if __name__ == '__main__':
  main()
