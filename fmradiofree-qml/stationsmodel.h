#ifndef STATIONSMODEL_H
#define STATIONSMODEL_H

#include <QAbstractListModel>

class CListItem : public QObject
{
    Q_OBJECT

public:
    CListItem(QObject* parent = 0) : QObject(parent) {}
    virtual ~CListItem() {}
    virtual QString id() const = 0;
    virtual QVariant data(int role) const = 0;
    virtual QHash<int, QByteArray> roleNames() const = 0;

signals:
    void dataChanged();
};

class CStationItem : public CListItem
{
    Q_OBJECT

public:
    enum Roles {
        UserNameRole = Qt::UserRole+1,
        RdsNameRole,
        FreqRole,
        RdsTextRole
    };

public:
    CStationItem(QObject *parent = 0): CListItem(parent) {}
    explicit CStationItem(const QString &username, const QString &rdsname,
                          const qreal &freq, const QString &rdstext,
                          QObject *parent = 0);

    QVariant data(int role) const;
    QHash<int, QByteArray> roleNames() const;

    inline QString id() const { return m_username; }
    inline void setUserName(QString name) { m_username = name; emit dataChanged(); }
    inline QString username() const { return m_username; }
    inline QString rdsname() const { return m_rdsname; }
    inline qreal freq() const { return m_freq; }
    inline void setFreq(qreal f) { m_freq = f; emit dataChanged();}
    inline QString rdstext() const { return m_rdstext;}
private:
    QString m_username;
    QString m_rdsname;
    qreal m_freq;
    QString m_rdstext;
};

class StationsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit StationsModel(CListItem* prototype, QObject* parent = 0);
    ~StationsModel();
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    void appendRow(CListItem* item);
    void appendRows(const QList<CListItem*> &items);
    void insertRow(int row, CListItem* item);
    bool removeRow(int row, const QModelIndex &parent = QModelIndex());
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex());
    CListItem* takeRow(int row);
    CListItem* find(const QString &id);
    CListItem* find(const qreal &freq);
    QModelIndex indexFromItem( const CListItem* item) const;
    void clear();

public slots:
    int indexByFreq(double freq);
    void addNewStation(double freq, QString name);
    void deleteStation(int index);
    QString nameByIndex(int index);
    qreal freqByIndex(int index);
    QString rdsByIndex(int index);
    int nearestIndex(double freq, bool forward);
    void deleteAll();

private slots:
    void handleItemChange();

private:
    void sortByFreq();

private:
    CListItem* m_prototype;
    QList<CListItem*> m_list;
    
};

#endif // STATIONSMODEL_H
