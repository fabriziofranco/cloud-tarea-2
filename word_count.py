import sys
import time
import shutil
from pyspark import SparkContext, SparkConf

conf = SparkConf()
conf.set("spark.io.compression.codec", "org.apache.spark.io.LZ4CompressionCodec")

if __name__ == "__main__":
    sc = SparkContext(appName="WordCount", conf=conf)
    lines = sc.textFile(sys.argv[1])
    cleaned_lines = lines.map(lambda x: x.lower()) \
                     .map(lambda x: x.replace('"', '')) \
                     .map(lambda x: x.replace('(', '')) \
                     .map(lambda x: x.replace(')', '')) \
                     .map(lambda x: x.replace(',', '')) \
                     .map(lambda x: x.replace('.', '')) \
                     .map(lambda x: x.replace('-', ' '))
    counts = cleaned_lines.flatMap(lambda line: line.split(" ")) \
            .map(lambda word: (word, 1)) \
            .reduceByKey(lambda a, b: a + b) \
            .sortBy(lambda x: x[1], ascending=False)
    shutil.rmtree(sys.argv[2], ignore_errors=True)
    counts.saveAsTextFile(sys.argv[2])
    time.sleep(30)
