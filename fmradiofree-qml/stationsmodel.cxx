#include "stationsmodel.h"

#include <QDebug>

CStationItem::CStationItem(const QString &username, const QString &rdsname,
                           const qreal &freq, const QString &rdstext,
                           QObject *parent) :
    CListItem(parent),
    m_username(username),
    m_rdsname(rdsname),
    m_freq(freq),
    m_rdstext(rdstext)
{
}

QHash<int, QByteArray> CStationItem::roleNames() const
{
    QHash<int, QByteArray> names;
    names[UserNameRole] = "username";
    names[RdsNameRole] = "rdsname";
    names[FreqRole] = "freq";
    names[RdsTextRole] = "rdstext";
    return names;
}

QVariant CStationItem::data(int role) const
{
    switch(role) {
    case UserNameRole:
        return username();
    case RdsNameRole:
        return rdsname();
    case FreqRole:
        return freq();
    case RdsTextRole:
        return rdstext();
    default:
        return QVariant();
    }
}

StationsModel::StationsModel(CListItem* prototype, QObject *parent) :
    QAbstractListModel(parent), m_prototype(prototype)
{
    setRoleNames(m_prototype->roleNames());
}

int StationsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_list.size();
}

QVariant StationsModel::data(const QModelIndex &index, int role) const
{
    if(index.row() < 0 || index.row() >= m_list.size())
        return QVariant();
    return m_list.at(index.row())->data(role);
}

StationsModel::~StationsModel() {
    delete m_prototype;
    clear();
}

void StationsModel::appendRow(CListItem *item)
{
    appendRows(QList<CListItem*>() << item);
}

void StationsModel::appendRows(const QList<CListItem *> &items)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount()+items.size()-1);
    foreach(CListItem *item, items) {
        connect(item, SIGNAL(dataChanged()), SLOT(handleItemChange()));
        m_list.append(item);
    }
    endInsertRows();
}

void StationsModel::insertRow(int row, CListItem *item)
{
    beginInsertRows(QModelIndex(), row, row);
    connect(item, SIGNAL(dataChanged()), SLOT(handleItemChange()));
    m_list.insert(row, item);
    endInsertRows();
}

void StationsModel::handleItemChange()
{
    CListItem* item = static_cast<CListItem*>(sender());
    QModelIndex index = indexFromItem(item);
    if(index.isValid())
        emit dataChanged(index, index);
}

CListItem * StationsModel::find(const QString &id)
{
    foreach(CListItem* item, m_list) {
        if(item->id() == id) return item;
    }
    return 0;
}

CListItem * StationsModel::find(const qreal &freq)
{
    foreach(CListItem* item, m_list) {
        if(item->data(CStationItem::FreqRole).toDouble() == freq)
        {
            return item;
        }
    }
    return NULL;
}

QModelIndex StationsModel::indexFromItem(const CListItem *item) const
{
    Q_ASSERT(item);
    for(int row=0; row<m_list.size(); ++row) {
        if(m_list.at(row) == item) return index(row);
    }
    return QModelIndex();
}

void StationsModel::clear()
{
    qDeleteAll(m_list);
    m_list.clear();
}

bool StationsModel::removeRow(int row, const QModelIndex &parent)
{
    Q_UNUSED(parent);
    if(row < 0 || row >= m_list.size()) return false;
    beginRemoveRows(QModelIndex(), row, row);
    delete m_list.takeAt(row);
    endRemoveRows();
    return true;
}

bool StationsModel::removeRows(int row, int count, const QModelIndex &parent)
{
    Q_UNUSED(parent);
    if(row < 0 || (row+count) >= m_list.size()) return false;
    beginRemoveRows(QModelIndex(), row, row+count-1);
    for(int i=0; i<count; ++i) {
        delete m_list.takeAt(row);
    }
    endRemoveRows();
    return true;
}

CListItem * StationsModel::takeRow(int row)
{
    beginRemoveRows(QModelIndex(), row, row);
    CListItem* item = m_list.takeAt(row);
    endRemoveRows();
    return item;
}

int StationsModel::indexByFreq(double freq)
{
    for(int i = 0; i < m_list.count(); i++)
    {
        if(freq == m_list[i]->data(CStationItem::FreqRole).toDouble())
        {
            return i;
        }
    }
    return -1;
}

void StationsModel::addNewStation(double freq, QString name)
{
    CListItem * item = find(freq);
    if( item == NULL)
    {
        QString rdsname,rdstext;
        appendRow(new CStationItem(name,rdsname,freq,rdstext,this));
    }else{
        // edit
        CStationItem * si = qobject_cast<CStationItem*>(item);
        if(si != NULL)
        {
            si->setUserName(name);
            si->setFreq(freq);
        }
    }
    sortByFreq();
}

void StationsModel::deleteStation(int row)
{
    if(row >= 0 && row < m_list.count())
    {
        CListItem * item = takeRow(row);
        if(item != NULL)
            delete item;
    }
}

QString StationsModel::nameByIndex(int row)
{
    if(row >= 0 && row < m_list.count())
    {
        CListItem * item = m_list[row];
        if(item != NULL)
        {
            return item->data(CStationItem::UserNameRole).toString();
        }
    }
    return QString();
}

qreal StationsModel::freqByIndex(int row)
{
    if(row >= 0 && row < m_list.count())
    {
        CListItem * item = m_list[row];
        if(item != NULL)
        {
            return item->data(CStationItem::FreqRole).toDouble();
        }
    }
    return 87.5;
}

QString StationsModel::rdsByIndex(int row)
{
    if(row >= 0 && row < m_list.count())
    {
        CListItem * item = m_list[row];
        if(item != NULL)
        {
            return item->data(CStationItem::RdsNameRole).toString();
        }
    }
    return QString();
}

void StationsModel::deleteAll()
{
    beginResetModel();
    clear();
    endResetModel();
}

int StationsModel::nearestIndex(double freq, bool forward)
{
    int ret = -1;
    double div = freq;
    for(int i = 0; i < m_list.count(); i++)
    {
        double f = m_list[i]->data(CStationItem::FreqRole).toDouble();
        if(forward)
        {
            if(f > freq)
            {
                if(f - freq < div)
                {
                    div = f - freq;
                    ret = i;
                }
            }
        }else{
            if( f < freq)
            {
                if ( freq - f < div)
                {
                    div = freq - f;
                    ret = i;
                }
            }
        }
    }

    return ret;
}

void StationsModel::sortByFreq()
{
    beginResetModel();
    for(int i = 0; i < m_list.count(); i++)
    {
        for(int j = i+1; j < m_list.count(); j++)
        {
            double f1 = m_list[i]->data(CStationItem::FreqRole).toDouble();
            double f2 = m_list[j]->data(CStationItem::FreqRole).toDouble();
            if(f1 > f2)
            {
                CListItem * item = m_list[i];
                m_list[i] = m_list[j];
                m_list[j] = item;
            }
        }
    }
    endResetModel();
}
