import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Circle
import tensorflow as tf
from sklearn.model_selection import train_test_split
from tensorflow import keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Flatten
from tensorflow.keras.layers import Conv2D, MaxPooling2D, BatchNormalization
from tensorflow.keras import backend as K
import cv2

def read_train_data():
    path = 'neural_network_data_inwindow/'
    n_images = 100
    x = []
    y = []
    with open(path+'labels.txt', 'r') as f:
        for i in range(n_images):
            I = plt.imread(path+'img'+str(i)+'.jpg')[:,:,1]
            I = np.expand_dims(I, axis=2)
            x.append(I)
            label_str = f.readline()
            coord_str = label_str.split(',')
            y.append(np.array([int(coord_str[0]), int(coord_str[1])]))
    return np.array(x),np.array(y)

def read_run_data(path):
    x = cv2.imread(path)
    orig_size = x.shape
    print(orig_size)
    x = cv2.cvtColor(x, cv2.COLOR_RGB2GRAY)
    x = cv2.resize(x, (250,250))
    x = np.expand_dims(x, axis=2)
    x = np.expand_dims(x, axis=0)
    x = x.astype('float32')
    x /= 255
    scale = [orig_size[0]/250, orig_size[1]/250]
    print(scale)
    # I = plt.imread(path)[:,:,1]
    # I = np.expand_dims(I, axis=2)
    # I = np.expand_dims(I, axis=0)
    # I = I.astype('float32')
    # I /= 255
    return x, scale

def build_small_model():
    model = Sequential()
    model.add(Flatten(input_shape=(250,250,1)))
    model.add(Dense(2))

    model.compile(loss=keras.losses.mean_squared_error,
              optimizer=keras.optimizers.Adam(),
              metrics=[])

    model.summary()

    return model

def build_model2():
    model = Sequential()
    model.add(Conv2D(48, kernel_size=(11, 11),
                 activation='relu',
                 input_shape=(250,250,1)))
    model.add(BatchNormalization())
    model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))
    model.add(Conv2D(128, (5, 5), activation='relu'))
    model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))
    model.add(Conv2D(192, (3, 3), activation='relu'))
    model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))
    model.add(Conv2D(192, (3, 3), activation='relu'))
    model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))
    model.add(Conv2D(128, (3, 3), activation='relu'))
    model.add(MaxPooling2D(pool_size=(3, 3), strides=(3, 3)))
    model.add(Flatten())
    model.add(Dense(1024, activation='relu'))
    model.add(BatchNormalization())
    model.add(Dropout(0.5))
    model.add(Dense(1024, activation='relu'))
    model.add(BatchNormalization())
    model.add(Dropout(0.5))
    model.add(Dense(2))

    model.compile(loss=keras.losses.mean_squared_error,
              optimizer=keras.optimizers.Adam(),
              metrics=[])

    model.summary()

    return model

def build_model():
    model = Sequential()
    model.add(Conv2D(32, kernel_size=(5, 5),
                 activation='relu',
                 input_shape=(250,250,1)))
    model.add(MaxPooling2D(pool_size=(8, 8), strides=(8, 8)))
    model.add(Conv2D(64, (5, 5), activation='relu'))
    model.add(MaxPooling2D(pool_size=(4, 4), strides=(4, 4)))
    # model.add(Dropout(0.25))
    model.add(Flatten())
    model.add(Dense(128, activation='relu'))
    # model.add(Dropout(0.5))
    model.add(Dense(2))

    model.compile(loss=keras.losses.mean_squared_error,
              optimizer=keras.optimizers.Adam(),
              metrics=[])

    model.summary()

    return model


def train_network():
    x,y = read_train_data()
    x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.05, random_state=5)

    x_train = x_train.astype('float32')
    x_test = x_test.astype('float32')
    x_train /= 255
    x_test /= 255
    y_train = y_train.astype('float32')
    y_test = y_test.astype('float32')


    model = build_small_model()

    epochs = 30
    batch_size = 5

    model.fit(x_train, y_train,
          batch_size=batch_size,
          epochs=epochs,
          verbose=1,
          validation_data=(x_test, y_test))

    model.save_weights('rotation_center_net_weights_constbrightness')

    score = model.evaluate(x_test, y_test, verbose=0)
    print('Test loss:', score)

    predictions = model.predict(x_test)
    plt.ion()
    fig,ax = plt.subplots(1)
    plt.show()
    for i in range(predictions.shape[0]):
        ax.imshow(np.squeeze(x_test[i]), cmap='gray')
        circ = Circle((predictions[i,0],predictions[i,1]), radius=50, fill=False, color='red')
        ax.add_patch(circ)
        print('Prediction: ', predictions[i,:])
        print('Actual: ', y_test[i,:])
        plt.draw()
        input("Press [enter] to continue.")
        circ.remove()


def run_network(path):
    model = build_model()
    model.load_weights('rotation_center_net_weights_largescale')
    x_test, _ = read_train_data()
    x_test = x_test.astype('float32')
    x_test /= 255
    predictions = model.predict(x_test)
    plt.ion()
    fig,ax = plt.subplots(1)
    plt.show()
    for i in range(predictions.shape[0]):
        ax.imshow(np.squeeze(x_test[i]), cmap='gray')
        circ = Circle((predictions[i,0],predictions[i,1]), radius=50, fill=False, color='red')
        ax.add_patch(circ)
        print('Prediction: ', predictions[i,:])
        plt.draw()
        input("Press [enter] to continue.")
        circ.remove()
    # I = plt.imread(path)
    # x, scale = read_run_data(path)
    # #scale = [1,1]
    # model = build_model()
    # model.load_weights('rotation_center_net_weights_constbrightness')
    # prediction = model.predict(x)
    # fig,ax = plt.subplots(1)
    # ax.imshow(I)
    # circ = Circle((prediction[0,0]*scale[0],prediction[0,1]*scale[1]), radius=100, fill=False, color='red')
    # ax.add_patch(circ)
    # print('Prediction: ', prediction[0,:]*scale)
    # plt.show()


if __name__ == '__main__':
    run_network('')
    # test_path = 'stock_photos/star_trail_test.jpg'
    # run_network(test_path)
    # train_network()
