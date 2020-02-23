
#include "entry.h"
#include <QDebug>
#include <QDateTime>
#include <QJsonObject>
#include <QJsonArray>

#define JSON_IS_LIST(field) json.contains(#field) && json[#field].isArray()

#define JSON_IS_OBJECT(field) json.contains(#field) && json[#field].isObject()

#define JSON_IS_STRING(field) json.contains(#field) && json[#field].isString()

#define JSON_IS_NUMBER(field) json.contains(#field) && json[#field].isDouble()

#define JSON_READ_STRING(field) \
    if (JSON_IS_STRING(field)) \
        field = json[#field].toString(); \
//    else qDebug() << #field " is not a string.";

#define JSON_READ_INT(field) \
    if (JSON_IS_NUMBER(field)) \
        field = json[#field].toInt(); \
//    else qDebug() << #field " is not a number (int).";

#define JSON_READ_REAL(field) \
    if (JSON_IS_NUMBER(field)) \
        field = json[#field].toDouble(); \
//    else qDebug() << #field " is not a number (real).";

#define JSON_READ_OBJECT(field, Type) \
    if (JSON_IS_OBJECT(field)) { \
        field = Type(); \
        field.read(json[#field].toObject()); \
    } \
//    else qDebug() << #field " is not an object.";

#define JSON_FOR_LIST(field, value) \
    if (JSON_IS_LIST(field)) \
        for (QJsonValue value : json[#field].toArray())

#define JSON_WRITE(field) json[#field] = field

#define JSON_WRITE_OBJECT(field) \
    { \
        QJsonObject object; \
        field.write(object); \
        json[#field] = object; \
    }

#define OBJECT_READ_INT(target, field) \
    if (object.contains(#field)) { \
        (target).field = object[#field].toInt(); \
    }

#define OBJECT_READ_REAL(target, field) \
    if (object.contains(#field)) { \
        (target).field = object[#field].toReal(); \
    }

#define OBJECT_READ_STRING(target, field) \
    if (object.contains(#field)) { \
        (target).field = object[#field].toString(); \
    }

#define OBJECT_FOR_LIST(field, value) \
    if (object.contains(#field)) \
        for (QVariant value : object[#field].toList())


void EntryPosition::operator=(const EntryPosition &other) {
    latitude = other.latitude;
    longitude = other.longitude;
    altitude = other.altitude;
}

bool EntryPosition::operator==(const EntryPosition &other) const {
    return latitude == other.latitude &&
        longitude == other.longitude &&
        altitude == other.altitude;
}

void EntryPosition::read(const QJsonObject &json) {
    JSON_READ_REAL(latitude);
    JSON_READ_REAL(longitude);
    JSON_READ_REAL(altitude);
}

void EntryPosition::write(QJsonObject &json) const {
    JSON_WRITE(latitude);
    JSON_WRITE(longitude);
    JSON_WRITE(altitude);
}

EntryPosition EntryPosition::fromObject(const QVariantMap &object) {
    EntryPosition position;
    
    OBJECT_READ_REAL(position, latitude);
    OBJECT_READ_REAL(position, longitude);
    OBJECT_READ_REAL(position, altitude);
    
    return position;
}

void EntryField::operator=(const EntryField &other) {
    name = other.name;
    type = other.type;
    value = other.value;
}

bool EntryField::operator==(const EntryField &other) const {
    return name == other.name &&
        type == other.type &&
        value == other.value;
}

void EntryField::read(const QJsonObject &json) {
    JSON_READ_STRING(name);
    JSON_READ_STRING(value);
    JSON_READ_STRING(type);
}

void EntryField::write(QJsonObject &json) const {
    JSON_WRITE(name);
    JSON_WRITE(type);
    
    if (!value.isEmpty()) {
        JSON_WRITE(value);
    }
}

EntryField EntryField::fromObject(const QVariantMap &object) {
    EntryField field;
    
    OBJECT_READ_STRING(field, name);
    OBJECT_READ_STRING(field, type);
    OBJECT_READ_STRING(field, value);
    
    return field;
}
void Entry::operator=(const Entry &other) {
    entry_id = other.entry_id;
    entry_set_id = other.entry_set_id;
    timestamp = other.timestamp;
    voucher = other.voucher;
    collector = other.collector;
    position = other.position;
    images = QStringList(other.images);
    fields = QList<EntryField>(other.fields);
}

bool Entry::operator==(const Entry &other) const {
    return entry_id == other.entry_id &&
        entry_set_id == other.entry_set_id &&
        timestamp == other.timestamp &&
        voucher == other.voucher &&
        collector == other.collector &&
        position == other.position &&
        images == other.images &&
        fields == other.fields;
}

QMap<QString, EntryField> Entry::getFieldMap() const {
    QMap<QString, EntryField> map;
    
    for (EntryField field : fields) {
        map[field.name] = field;
    }
    
    return map;
}

void Entry::read(const QJsonObject &json) {
    JSON_READ_INT(entry_id);
    JSON_READ_INT(entry_set_id);
    JSON_READ_STRING(voucher);
    JSON_READ_OBJECT(position, EntryPosition);
    JSON_READ_STRING(timestamp);
    JSON_READ_STRING(collector);
    
    images.clear();
    JSON_FOR_LIST(images, value) {
        if (value.isString()) {
            images.append(value.toString());
        }
    }
    
    fields.clear();
    JSON_FOR_LIST(fields, value) {
        if (value.isObject()) {
            EntryField item;
            item.read(value.toObject());
            fields.append(item);
        }
    }
}

void Entry::write(QJsonObject &json) const {
    
    JSON_WRITE(entry_id);
    JSON_WRITE(entry_set_id);
    JSON_WRITE(voucher);
    JSON_WRITE_OBJECT(position);
    JSON_WRITE(timestamp);
    JSON_WRITE(collector);
    
    {
        QJsonArray array;
        for (QString image : images) {
            array.append(image);
        }
        json["images"] = array;
    }
    
    {
        QJsonArray array;
        for (EntryField field : fields) {
            QJsonObject object;
            field.write(object);
            array.append(object);
        }
        json["fields"] = array;
    }
}

Entry Entry::fromObject(const QVariantMap &object) {
    Entry entry;
    
    OBJECT_READ_INT(entry, entry_id);
    OBJECT_READ_INT(entry, entry_set_id);
    OBJECT_READ_STRING(entry, timestamp);
    OBJECT_READ_STRING(entry, voucher);
    OBJECT_READ_STRING(entry, collector);
    
    if (object.contains("position")) {
        entry.position = EntryPosition::fromObject(object["position"].toMap());
    }
    
    OBJECT_FOR_LIST(images, item) {
        entry.images.append(item.toString());
    }
    
    OBJECT_FOR_LIST(fields, item) {
        EntryField field = item.canConvert<EntryField>()
            ? item.value<EntryField>()
            : EntryField::fromObject(item.toMap());
        
        entry.fields.append(field);
    }
    
    return entry;
}

void EntrySet::operator=(const EntrySet &other) {
    voucher_format = other.voucher_format;
    collector = other.collector;
    entries = QMap<int, Entry>(other.entries);
    fields = QList<EntryField>(other.fields);
}

bool EntrySet::operator==(const EntrySet &other) const {
    return set_id == other.set_id &&
        voucher_format == other.voucher_format &&
        collector == other.collector &&
        fields == other.fields &&
        entries == other.entries;
}

QStringList EntrySet::getFieldNames() const {
    QStringList names;
    
    for (const EntryField field : fields) {
        names.append(field.name);
    }
    
    return names;
}

QList<Entry> EntrySet::getEntries() const {
    return entries.values();
}

QString EntrySet::getNextVoucher() const {
    QByteArray format = voucher_format.toUtf8();
    const char *cformat = format.constData();
    
    return QString::asprintf(cformat, entry_count + 1);
}

void EntrySet::read(const QJsonObject &json) {
    JSON_READ_INT(set_id);
    JSON_READ_STRING(name);
    JSON_READ_STRING(collector);
    JSON_READ_STRING(voucher_format);
    JSON_READ_INT(entry_count);
    
    fields.clear();
    JSON_FOR_LIST(fields, value) {
        if (value.isObject()) {
            EntryField field;
            field.read(value.toObject());
            fields.append(field);
        }
    }
    
    entries.clear();
    JSON_FOR_LIST(entries, value) {
        if (value.isObject()) {
            Entry entry;
            entry.read(value.toObject());
            entries.insert(entry.entry_id, entry);
        }
    }
}

void EntrySet::write(QJsonObject &json) const {
    
    JSON_WRITE(set_id);
    JSON_WRITE(name);
    JSON_WRITE(collector);
    JSON_WRITE(voucher_format);
    JSON_WRITE(entry_count);
    
    {
        QJsonArray array;
        for (EntryField field : fields) {
            QJsonObject object;
            field.write(object);
            array.append(object);
        }
        json["fields"] = array;
    }
    {
        QJsonArray array;
        for (Entry entry : entries) {
            QJsonObject object;
            entry.write(object);
            array.append(object);
        }
        json["entries"] = array;
    }
}

EntrySet EntrySet::fromObject(const QVariantMap &object) {
    EntrySet set;
    
    OBJECT_READ_INT(set, set_id);
    OBJECT_READ_STRING(set, name);
    OBJECT_READ_STRING(set, collector);
    OBJECT_READ_STRING(set, voucher_format);
    
    OBJECT_FOR_LIST(fields, item) {
        EntryField field = item.canConvert<EntryField>()
            ? item.value<EntryField>()
            : EntryField::fromObject(item.toMap());
        
        set.fields.append(field);
    }
    
    return set;
}

int EntryDatabase::setEntry(const Entry &entry) {
    int set_id = entry.entry_set_id;
    
    if (sets.contains(set_id)) {
        int count = sets[set_id].entries.size();
        
        sets[set_id].entries.insert(entry.entry_id, entry);
        
        if (count != sets[set_id].entries.size()) {
            sets[set_id].entry_count++;
            entry_count++;
        }
        
        return sets.keys().indexOf(set_id);
    }
    
    return -1;
}

int EntryDatabase::setSet(const EntrySet &set) {
    int count = sets.size();
    sets.insert(set.set_id, set);
    
    if (count != sets.size()) {
        entry_set_count++;
    }
    
    return sets.keys().indexOf(set.set_id);
}

int EntryDatabase::read(const QJsonObject &json) {
    JSON_READ_INT(entry_count);
    JSON_READ_INT(entry_set_count);
    
    int entryCount = 0;
    
    JSON_FOR_LIST(data, value) {
        if (value.isObject()) {
            EntrySet set;
            set.read(value.toObject());
            
            sets.insert(set.set_id, set);
            entryCount += sets.size();
        }
    }
    
    return entryCount;
}

void EntryDatabase::write(QJsonObject &json) const {
    
    JSON_WRITE(entry_count);
    JSON_WRITE(entry_set_count);
    
    QJsonArray data;
    
    for (EntrySet set : sets) {
        QJsonObject object;
        set.write(object);
        data.append(object);
    }
    
    json["data"] = data;
}


void EntryTemplate::operator=(const EntryTemplate &other) {
    name = other.name;
    author = other.author;
    fields = other.fields;
}

bool EntryTemplate::operator==(const EntryTemplate &other) const {
    return name == other.name &&
        author == other.author &&
        fields == other.fields;
}

void EntryTemplate::read(const QJsonObject &json) {
    JSON_READ_STRING(name);
    JSON_READ_STRING(author);
    
    fields.clear();
    JSON_FOR_LIST(fields, value) {
        if (value.isObject()) {
            EntryField field;
            field.read(value.toObject());
            fields.append(field);
        }
    }
}

void EntryTemplate::write(QJsonObject &json) const {
    JSON_WRITE(name);
    JSON_WRITE(author);
    
    QJsonArray array;
    for (EntryField field : fields) {
        QJsonObject object;
        field.write(object);
        array.append(object);
    }
    
    json["fields"] = array;
}

