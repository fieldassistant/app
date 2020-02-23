#include <QtTest/QtTest>

#include "../csvwriter.h"

class CsvWriterTest : public QObject {
    Q_OBJECT
    
private slots:
    void test();
    
};

void CsvWriterTest::test() {
    
    QString file;
    CsvWriter writer(&file);
    
    writer.write("one");
    writer.write("two");
    writer.write("three,four");
    writer.newRow();
    
    writer.write("abc");
    writer.write(QString("uhh\" nice"));
    writer.write(QVariant("This \n is \r a mess \"  "));
    writer.newRow();
    writer.writeList({1, 2.345, 6.0, "neat"});
    writer.write({"neat", "stuff"});
    writer.newRow();
    
//    qDebug() << csv;
    
    QString expected =
        "one,two,\"three,four\"\n"
        "abc,\"uhh\\\" nice\",\"This   is   a mess \\\"\"\n"
        "1,2.345,6.0,neat\n"
        "neat,stuff\n"
    ;
    
    QCOMPARE(file, expected);
}

QTEST_MAIN(CsvWriterTest)

#include "tst_csvbuildertest.moc"
