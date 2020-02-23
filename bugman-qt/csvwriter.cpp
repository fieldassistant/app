#include "csvwriter.h"

#include <QTextStream>
#include <QIODevice>
#include <QRegularExpression>
#include <QDateTime>

static const auto DIRTY_RE = QRegularExpression("[ ,'\"\\r\\n]");
static const auto BREAK_RE = QRegularExpression("[\\r\\n]+");

const QString cleanString(const QString &str) {
    
    const auto match = DIRTY_RE.match(str);
    
    if (match.hasMatch()) {
        QString dirty(str);
        dirty.replace(BREAK_RE, " ");
        dirty.replace("\"", "\\\"");
        
        dirty = dirty.trimmed();
        dirty.prepend("\"");
        dirty.append("\"");
        
        return dirty;
    }
    else {
        return str.trimmed();
    }
}

const QString cleanZeros(const QString &num) {
    QString dirty(num);
    
    int i = num.length() - 1;
    for (; i >= 0 && num[i] == '0'; i--);
    if (num[i] == '.') i++;
    
    dirty.remove(i + 1, num.length());
    
    return dirty;
}

CsvWriter::CsvWriter(QIODevice* file) {
    stream = new QTextStream(file);
}

CsvWriter::CsvWriter(QString* file) {
    stream = new QTextStream(file);
}

CsvWriter::~CsvWriter() {
    delete stream;
}

CsvWriter& CsvWriter::write(const QVariant &item) {
    
    if (item.type() == QVariant::String) {
        return write(item.toString());
    }
    
    if (item.type() == QVariant::Int) {
        return write(item.toInt());
    }
    
    if (item.type() == QVariant::Double) {
        return write(item.toDouble());
    }
    
    if (item.type() == QVariant::Date) {
        return write(item.toDate());
    }
    
    if (item.type() == QVariant::Time) {
        return write(item.toTime());
    }
    
    if (item.type() == QVariant::DateTime) {
        return write(item.toDateTime());
    }
    
    if (item.type() == QVariant::List) {
        for (const QVariant &item : item.toList()) {
            write(item);
        }
        return *this;
    }
    
    return write(item.toString());
}

CsvWriter& CsvWriter::write(const QDateTime &item) {
    return write(item.toString(Qt::ISODate));
}

CsvWriter& CsvWriter::write(const QDate &item) {
    return write(item.toString(Qt::ISODate));
}

CsvWriter& CsvWriter::write(const QTime &item) {
    return write(item.toString(Qt::ISODate));
}

CsvWriter& CsvWriter::write(const QString &item) {
    if (rowCount++) (*stream) << ",";
    (*stream) << cleanString(item);
    return *this;
}

CsvWriter& CsvWriter::write(const char* item) {
    return write(QString::fromLocal8Bit(item));
}

CsvWriter& CsvWriter::write(const int item) {
    return write(QString::number(item));
}

CsvWriter& CsvWriter::write(const qreal item) {
    return write(cleanZeros(QString::number(item, 'f', 8)));
}

CsvWriter& CsvWriter::write(std::initializer_list<QVariant> list) {
    return write(QVariantList(list));
}

CsvWriter& CsvWriter::writeList(QVariantList list) {
    write(list);
    return newRow();
}

CsvWriter& CsvWriter::newRow() {
    rowCount = 0;
    (*stream) << "\n";
    return *this;
}
