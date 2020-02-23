#ifndef CSVWRITER_H
#define CSVWRITER_H

#include <QVariant>

class QTextStream;
class QIODevice;

class CsvWriter {
    
    QTextStream* stream;
    int rowCount = 0;
    
public:
    CsvWriter(QIODevice* file);
    CsvWriter(QString* file);
    ~CsvWriter();
    
    CsvWriter& write(const QVariant &item);
    CsvWriter& write(const QString &item);
    CsvWriter& write(const QDateTime &item);
    CsvWriter& write(const QDate &item);
    CsvWriter& write(const QTime &item);
    CsvWriter& write(const char* item);
    CsvWriter& write(const int item);
    CsvWriter& write(const qreal item);
    CsvWriter& write(std::initializer_list<QVariant> list);
    CsvWriter& writeList(QVariantList list);
    CsvWriter& newRow();
};

#endif // CSVWRITER_H
